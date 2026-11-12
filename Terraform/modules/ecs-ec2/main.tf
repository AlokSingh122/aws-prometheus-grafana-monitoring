data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "monitoring-ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  iam_instance_profile {
    name = var.instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-USERDATA
    #!/bin/bash
    echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
    systemctl enable --now ecs
    USERDATA
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ecs-container-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs" {
  name                      = "ecs-monitoring-asg"
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 1
  wait_for_capacity_timeout = "10m"
  vpc_zone_identifier       = [var.subnet_id]

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-container-instance"
    propagate_at_launch = true
  }
}

data "aws_instances" "ecs" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ecs.name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [aws_autoscaling_group.ecs]
}

data "aws_instance" "ecs" {
  instance_id = data.aws_instances.ecs.ids[0]
}
