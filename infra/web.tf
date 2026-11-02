resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail
dnf update -y
dnf install -y nginx
cat > /usr/share/nginx/html/index.html <<'HTML'
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Netflix Style 3-Tier</title></head>
<body style="font-family:Arial;background:#141414;color:white;text-align:center;padding:5rem">
<h1>Netflix Style 3-Tier Application</h1>
<p>Presentation Tier — Nginx Web Server</p>
<p id="result">Connecting to application tier...</p>
<script>
Promise.all([
  fetch('/api').then(response => {
    if (!response.ok) throw new Error('Application API unavailable');
    return response.json();
  }),
  fetch('/api/db-health').then(response => {
    if (!response.ok) throw new Error('Database unavailable');
    return response.json();
  })
])
  .then(([app, db]) => {
    document.getElementById('result').textContent =
      app.application + ' | App: ' + app.status + ' | Database: ' + db.database;
  })
  .catch(() => {
    document.getElementById('result').textContent = 'Application or database tier unavailable';
  });
</script>
</body>
</html>
HTML

rm -f /etc/nginx/conf.d/default.conf

cat > /etc/nginx/conf.d/app-proxy.conf <<'NGINX'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

}
NGINX

nginx -t
systemctl enable --now nginx
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags           = { Name = "${var.project_name}-web" }
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-web-asg"
  min_size            = 1
  desired_capacity    = 1
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.web_a.id, aws_subnet.web_b.id]
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_cpu" {
  name                   = "${var.project_name}-web-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60
  }
}
