output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "rds_endpoint" {
  value     = aws_db_instance.mysql.address
  sensitive = true
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}
