variable ecr_region {
   description = "The region for ecr"
} 

variable docker_tag {
   description = "The common container image tag"
} 
variable container_cpu {
   description = "The common container cpu value"
} 
variable container_memory {
   description = "The common container memory value"
} 

variable support_srv_params {
   description = "The params for support services"
   type = "map"
} 



module "spring-config" {
  source = "github.com/soldierxue/terraformlib/ecs-service"

  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"config.service_name")}"
  family_name ="${lookup(var.support_srv_params,"config.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"config.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"config.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"config.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.support-alb.target_group_arns,index(var.support_alb_tg_names,lookup(var.support_srv_params,"config.tg_name")))}"
}

module "spring-eureka" {
  source = "github.com/soldierxue/terraformlib/ecs-service"

  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"eureka.service_name")}"
  family_name ="${lookup(var.support_srv_params,"eureka.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"eureka.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"eureka.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"eureka.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.support-alb.target_group_arns,index(var.support_alb_tg_names,lookup(var.support_srv_params,"eureka.tg_name")))}"
}

module "spring-eureka2" {
  source = "github.com/soldierxue/terraformlib/ecs-service"
  
  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"eureka2.service_name")}"
  family_name ="${lookup(var.support_srv_params,"eureka2.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"eureka2.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"eureka2.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"eureka2.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.support-alb.target_group_arns,index(var.support_alb_tg_names,lookup(var.support_srv_params,"eureka2.tg_name")))}"
}
