resource "aws_cloudwatch_metric_alarm" "web_asg_cpu" {
  alarm_name          = "${var.project_name}-web-asg-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Web tier average CPU is above 75 percent."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "app_asg_cpu" {
  alarm_name          = "${var.project_name}-app-asg-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Application tier average CPU is above 75 percent."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project_name}-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "RDS instance CPU is above 75 percent."

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.identifier
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "public_alb_5xx" {
  alarm_name          = "${var.project_name}-public-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Public ALB generated more than five 5xx responses in five minutes."

  dimensions = {
    LoadBalancer = aws_lb.public.arn_suffix
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name          = "${var.project_name}-rds-low-free-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 2000000000
  alarm_description   = "RDS free storage is below approximately 2 GB."

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.identifier
  }

  treat_missing_data = "notBreaching"
}
