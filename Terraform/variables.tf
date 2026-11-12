variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "ecs-monitoring"
}

variable "my_ip" {
  description = "Your public IPv4 CIDR in /32 notation for administrative access."
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip, 0)) && endswith(var.my_ip, "/32")
    error_message = "my_ip must be a valid IPv4 CIDR ending in /32."
  }
}

variable "ssh_key_name" {
  description = "Optional existing EC2 key pair name for SSH access."
  type        = string
  default     = null
}

variable "ecs_instance_type" {
  description = "EC2 instance type for the ECS container host."
  type        = string
  default     = "t3.micro"
}

variable "app_image_uri" {
  description = "Full ECR image URI, including tag. Set after pushing the image."
  type        = string
  default     = "placeholder"
}

variable "desired_count" {
  description = "Number of application tasks to run."
  type        = number
  default     = 1

  validation {
    condition     = var.desired_count >= 0
    error_message = "desired_count must be zero or greater."
  }
}
