# For AWS Cloud
provider "aws" {
  region = "${var.region}"
}

# models VPC

module "aws-vpc" {
  source          = "./infra-vpc"
  region          = "${var.region}"
  base_cidr_block = "${var.base_cidr_block}"
  ec2keyname = "${var.ec2keyname}"
  subnet_private2_cidr = "${var.subnet_private2_cidr}"
  subnet_private1_cidr = "${var.subnet_private1_cidr}"
  subnet_pub2_cidr = "${var.subnet_pub2_cidr}"
  subnet_pub1_cidr = "${var.subnet_pub1_cidr}"
}

# model: securities like Security Groups, IAM roles

module "securities" {
  source          = "./infra-security"
  vpc_id          = "${module.aws-vpc.vpc_id}"
  vpc_cidr_block  = "${var.base_cidr_block}"
}

# model : demo for PHP app(public subnet) + MySql db(private subnet)

module "demo-php" {
  source          = "./demo-php"
  vpc_id          = "${module.aws-vpc.vpc_id}"
  public_subnet_id = "${module.aws-vpc.public_subnet1_id}"
  fronend_web_sgid = "${module.securities.sg_frontend_id}"
  
  private_subnet_id = "${module.aws-vpc.private_subnet1_id}"
  database_sgid = "${module.securities.sg_database_id}"
  
  ec2keyname = "${var.ec2keyname["${var.region}"]}"
}

# model ALB for ECS Service

module "alb" {
  source = "./infra-alb"

  security_group_internal_id = "${module.securities.sg_internal_id}"
  security_group_inbound_id = "${module.securities.sg_frontend_id}"
  alb_subnet_ids = "${module.aws-vpc.subnet_public_ids}"
  vpc_id = "${module.aws-vpc.vpc_id}"
}

# Empty ECS Cluster with no tasks running

module "ecs-cluster" {
  source = "./infra-ecs"
  cluster_name = "${var.cluster_name}"

  instance_type = "${var.ecs_instance_type}"
  key_pair_name = "${var.ec2keyname["${var.region}"]}"
  instance_profile_name = "${module.securities.ecs_instance_profile_name}"
  security_group_ecs_instance_id = "${module.securities.sg_internal_id}"
  asg_min = "${var.asg_min}"
  asg_max = "${var.asg_max}"
  ecs_cluster_subnet_ids = "${module.aws-vpc.subnet_private_ids}"
  target_group_arn = "${module.alb.target_group_arn}"
}

# Demo: ECS Spring Hello World sample service

module "demo-hwservice" {
  source = "./demo-ecs-hw-service"
  cluster_name = "${var.cluster_name}"
  region = "${var.region}"
  service_name ="${var.service_name}"
  docker_image ="${var.docker_image}"
  docker_tag = "${var.docker_tag}"
  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${var.container_port}"
  desired_count ="${var.desired_count}"
  ecs_service_role_arn = "${module.securities.ecs_service_role_arn}"
  target_group_arn ="${module.alb.target_group_arn}"
}


