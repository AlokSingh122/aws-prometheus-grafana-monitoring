module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  aws_region   = var.aws_region
}

module "security" {
  source = "./modules/security"

  vpc_id = module.networking.vpc_id
  my_ip  = var.my_ip
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  project_name = var.project_name
}

module "ecs_ec2" {
  source = "./modules/ecs-ec2"

  project_name      = var.project_name
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.security.ecs_sg_id
  instance_profile  = module.iam.ecs_instance_profile
  cluster_name      = module.ecs_cluster.cluster_name
  instance_type     = var.ecs_instance_type
  ssh_key_name      = var.ssh_key_name
}

module "ecs_service" {
  source = "./modules/ecs-service"

  project_name       = var.project_name
  cluster_arn        = module.ecs_cluster.cluster_arn
  image_uri          = var.app_image_uri
  desired_count      = var.desired_count
  execution_role_arn = module.iam.task_execution_role_arn

  depends_on = [module.ecs_ec2]
}

module "monitoring_ec2" {
  source = "./modules/monitoring-ec2"

  project_name      = var.project_name
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.security.monitoring_sg_id
  instance_type     = var.ecs_instance_type
  ssh_key_name      = var.ssh_key_name
}
