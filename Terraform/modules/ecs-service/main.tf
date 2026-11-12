resource "aws_ecs_task_definition" "app" {
  family                   = "monitoring-app-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "256"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "monitoring-app"
      image     = var.image_uri
      essential = true
      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
        protocol      = "tcp"
      }]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "monitoring-app-service"
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
}
