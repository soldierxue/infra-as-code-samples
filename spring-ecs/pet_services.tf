# Here We defines the 4 pet-clinic services

module "owenr-service" {
  source = "github.com/soldierxue/terraformlib/ecs-service"

  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"owner.service_name")}"
  family_name ="${lookup(var.support_srv_params,"owner.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"owner.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"owner.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"owner.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.srv-alb.target_group_arns,index(var.srv_alb_tg_names,lookup(var.support_srv_params,"owner.tg_name")))}"

  pc_memberOfCount = "${lookup(var.place_constraint,"owner.memberOfCount")}"
  pc_memberOf_expression = "${lookup(var.place_constraint,"owner.expression")}"

  ps_type = "${lookup(var.place_strategy,"owner.type")}"
  ps_field = "${lookup(var.place_strategy,"owner.field")}"
}

module "pet-service" {
  source = "github.com/soldierxue/terraformlib/ecs-service"

  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"pet.service_name")}"
  family_name ="${lookup(var.support_srv_params,"pet.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"pet.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"pet.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"pet.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.srv-alb.target_group_arns,index(var.srv_alb_tg_names,lookup(var.support_srv_params,"pet.tg_name")))}"
}

module "vet-service" {
  source = "github.com/soldierxue/terraformlib/ecs-service"

  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"vet.service_name")}"
  family_name ="${lookup(var.support_srv_params,"vet.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"vet.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"vet.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"vet.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.srv-alb.target_group_arns,index(var.srv_alb_tg_names,lookup(var.support_srv_params,"vet.tg_name")))}"
}

module "visit-service" {
  source = "github.com/soldierxue/terraformlib/ecs-service"

  cluster_name = "${module.ecscluster1.cluster_name}"
  service_name ="${lookup(var.support_srv_params,"visit.service_name")}"
  family_name ="${lookup(var.support_srv_params,"visit.family_name")}"
  docker_image ="${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com/${lookup(var.support_srv_params,"visit.ecr_repo")}"
  docker_tag = "${var.docker_tag}"

  container_cpu = "${var.container_cpu}"
  container_memory = "${var.container_memory}"
  container_port = "${lookup(var.support_srv_params,"visit.container_port")}"
  desired_count = "${lookup(var.support_srv_params,"visit.task_desired_count")}"

  ecs_service_role_arn = "${module.ecscluster1.ecs_service_role_arn}"
  target_group_arn ="${element(module.srv-alb.target_group_arns,index(var.srv_alb_tg_names,lookup(var.support_srv_params,"visit.tg_name")))}"
}