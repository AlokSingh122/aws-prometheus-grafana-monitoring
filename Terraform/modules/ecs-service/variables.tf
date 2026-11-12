variable "project_name" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "image_uri" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "execution_role_arn" {
  type = string
}
