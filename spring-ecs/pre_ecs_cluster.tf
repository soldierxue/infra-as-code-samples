## Required Variables
variable stack_name {
   description = "The name of the ecs stack"
} 
variable ecs_cluster_name {
   description = "The name of ecs cluster"
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

data "aws_caller_identity" "current" {}

module "apstack" {
    source = "github.com/soldierxue/terraformlib"
    stack_name = "${var.stack_name}"
}

module "ecscluster1" {
    source = "github.com/soldierxue/terraformlib/ecs-cluster"
    stack_name ="${module.apstack.stack_name}"
    environment = "${module.apstack.environment}"

    cluster_name ="${var.ecs_cluster_name}"
    asg_min = "${var.asg_min}"
    asg_max = "${var.asg_max}"
    asg_desired_size = "${var.asg_desired_size}"
    key_pair_name  = "${var.key_pair_name}"
    security_group_ecs_instance_id = "${module.apstack.sg_internal_id}"
    ecs_cluster_subnet_ids = "${module.apstack.subnet_private_ids}"
}