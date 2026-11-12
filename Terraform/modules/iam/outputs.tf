output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs.name
}

output "task_execution_role_arn" {
  value = aws_iam_role.task_execution.arn
}
