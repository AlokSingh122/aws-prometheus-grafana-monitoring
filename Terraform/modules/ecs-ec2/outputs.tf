output "instance_id" {
  value = data.aws_instances.ecs.ids[0]
}

output "private_ip" {
  value = data.aws_instance.ecs.private_ip
}
