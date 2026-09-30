data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter { name = "name" values = ["al2023-ami-*-x86_64"] }
  filter { name = "virtualization-type" values = ["hvm"] }
}

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  iam_instance_profile { name = aws_iam_instance_profile.ec2.name }
  vpc_security_group_ids = [aws_security_group.application.id]

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y java-17-amazon-corretto maven git
mkdir -p /opt/netflix-style-app
cd /opt/netflix-style-app
git clone --depth 1 --branch develop https://github.com/nikhilmastud/Netflix-style-3-tier-application.git source
cd source/app
mvn -q -DskipTests package
cat > /etc/netflix-style-app.env <<'ENV'
SERVER_PORT=8080
DB_URL=jdbc:mysql://${aws_db_instance.mysql.address}:3306/${var.db_name}
DB_USERNAME=${var.db_username}
DB_PASSWORD=${var.db_password}
ENV
cat > /etc/systemd/system/netflix-style-app.service <<'SERVICE'
[Unit]
Description=Netflix Style Three Tier Spring Boot Application
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
EnvironmentFile=/etc/netflix-style-app.env
ExecStart=/usr/bin/java -jar /opt/netflix-style-app/source/app/target/three-tier-application-1.0.0.jar
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE
systemctl daemon-reload
systemctl enable --now netflix-style-app
EOF
  )

  tag_specifications { resource_type = "instance" tags = { Name = "${var.project_name}-app" } }
}

resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-asg"
  min_size = 2
  desired_capacity = 2
  max_size = 4
  vpc_zone_identifier = [aws_subnet.application_a.id, aws_subnet.application_b.id]
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.app.arn]
  launch_template { id = aws_launch_template.app.id version = "$Latest" }
  tag { key = "Name" value = "${var.project_name}-asg-instance" propagate_at_launch = true }
}

resource "aws_autoscaling_policy" "cpu" {
  name = "${var.project_name}-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification { predefined_metric_type = "ASGAverageCPUUtilization" }
    target_value = 60
  }
}
