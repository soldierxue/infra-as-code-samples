provider "aws" {
  region = "ap-northeast-1"
}

module "code_commit" {
   source = "github.com/soldierxue/terraformlib/code-commit"
   name = "cc_demo_jason"
}

module "ecr_reg" {
   source = "github.com/soldierxue/terraformlib/ecr"
   name = "ecr_demo_jason"
}

module "code_ecs_demo" {
   source = "github.com/soldierxue/terraformlib/devops-codex"
   deployment_option="Canary"
   name = "ecs-jason3"
   ecr_region ="ap-northeast-1"
   ecr_repo = "${module.ecr_reg.ecr_name}"
   ecs_region = "ap-northeast-1"
   ecs_cluster ="ecs_cdemo"
   ecs_service="hw0603"
   ecs_task_cpu =200
   ecs_task_memory =200
   ecs_task_port=8080
   ecs_task_desiredcount=2
   codex_region = "ap-northeast-1"
   codecommit_repo = "${module.code_commit.repo_name}"
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

    cluster_name ="ecs_cdemo"
    asg_min = "1"
    asg_max = "1"
    asg_desired_size = "1"
    key_pair_name  = "ap-north1-key"
    target_group_arn = "${module.alb.target_group_arn}"
    security_group_ecs_instance_id = "${module.apstack.sg_internal_id}"
    ecs_cluster_subnet_ids = "${module.apstack.subnet_private_ids}"
}

module "demo-hwservice" {
  source = "github.com/soldierxue/terraformlib/ecs-service"
  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="hw0603"
  docker_image ="188869792837.dkr.ecr.us-east-1.amazonaws.com/jasonreg"
  docker_tag = ""
  container_cpu = "200"
  container_memory = "300"
  container_port = "8080"
  desired_count ="1"
  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${module.alb.target_group_arn}"
}

