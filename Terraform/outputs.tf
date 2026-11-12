output "ecr_repository_url" {
  description = "URL of the application ECR repository."
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs_cluster.cluster_name
}

output "ecs_instance_id" {
  description = "ID of the ECS container instance."
  value       = module.ecs_ec2.instance_id
}

output "ecs_private_ip" {
  description = "Private IP address of the ECS container instance."
  value       = module.ecs_ec2.private_ip
}

output "monitoring_public_ip" {
  description = "Public IP address of the monitoring host."
  value       = module.monitoring_ec2.public_ip
}

output "monitoring_private_ip" {
  description = "Private IP address of the monitoring host."
  value       = module.monitoring_ec2.private_ip
}
