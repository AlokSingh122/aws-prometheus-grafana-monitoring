output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "monitoring_sg_id" {
  value = aws_security_group.monitoring.id
}
