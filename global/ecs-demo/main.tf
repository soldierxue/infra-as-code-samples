/*
 *  Samples to create a full vpc stack  with public/private subnets & NAT Gateways for private subnets
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, 
 *      (3) NAT Gateways
 *      (3) ALB & Target Group
 *      (4) ECS Cluster & ASG
 *      (5) Cloud Watch metrics
 */
 
## Required Variables

variable region {
   description = "The region for which AWS resources will be created"
}
variable ecr_region {
   description = "The region for ECR, so we support ecr from different region with codepipeline"
}
variable ecr_repo {
   description = "The name of the Docker image registry"
}

variable esc_cluster_name {
   description = "The name of the ECS cluster"
}

variable ecs_service_name {
   description = "The name of the service, it is the same with task family name in this demo"
}
variable ecs_family_name {
   description = "The faimil name of ecs task"
} 
 
variable stack_name {
   description = "The name of the ecs stack"
} 
variable asg_min {
   description = "The min size of the asg cluster"
} 
variable asg_max {
   description = "The max size of the asg cluster"
} 
variable asg_desired_size {
   description = "The desired size of the asg cluster"
} 
variable key_pair_name {
   description = "The name of key pair to logon to ecs instances"
} 

variable docker_tag {
   description = "The tag name for which  image to be deployed"
} 
variable container_cpu {
   description = "The reservation cpu "
} 
variable container_memory {
   description = "The reservation memory "
} 
variable container_port {
   description = "The port of the task"
} 
variable task_desired_count {
   description = "The desired number of the tasks"
} 

provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

module "apstack" {
    source = "github.com/soldierxue/terraformlib"
    stack_name = "${var.stack_name}"
}

module "alb" {
   source = "github.com/soldierxue/terraformlib/alb"
   name ="ecs"
   stack_name="${module.apstack.stack_name}"
   environment = "${module.apstack.environment}"
   security_group_internal_id = "${module.apstack.sg_internal_id}"
   security_group_inbound_id = "${module.apstack.sg_frontend_id}"
   alb_subnet_ids = "${module.apstack.subnet_public_ids}"
   vpc_id = "${module.apstack.vpc_id}"
}

module "ecscluster1" {
    source = "github.com/soldierxue/terraformlib/ecs-cluster"
    stack_name ="${module.apstack.stack_name}"
    environment = "${module.apstack.environment}"

    cluster_name ="${var.esc_cluster_name}"
    asg_min = "${var.asg_min}"
    asg_max = "${var.asg_max}"
    asg_desired_size = "${var.asg_desired_size}"
    key_pair_name  = "${var.key_pair_name}"
    target_group_arn = "${module.alb.target_group_arn}"
    security_group_ecs_instance_id = "${module.apstack.sg_internal_id}"
    ecs_cluster_subnet_ids = "${module.apstack.subnet_private_ids}"
}

module "demo-hwservice1" {
  source = "github.com/soldierxue/terraformlib/ecs-service"
  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${var.ecs_service_name}"
  family_name ="${var.ecs_family_name}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${var.ecr_repo}"
  docker_tag = "${var.docker_tag}"
  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${var.container_port}"
  desired_count ="${var.task_desired_count}"
  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${module.alb.target_group_arn}"
}