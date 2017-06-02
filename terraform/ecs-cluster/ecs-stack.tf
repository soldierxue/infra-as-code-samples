module "m_base" {
  source     = "../"
  name          = "${var.stack_name}"
  environment  = "${var.environment}"  
}

module "m_alb" {
  source     = "../alb"
  name ="${var.alb_name}"
  stack_name="${module.m_base.stack_name}"
  environment = "${module.m_base.environment}"
  
  security_group_internal_id = "${module.m_base.sg_internal_id}"
  security_group_inbound_id = "${module.m_base.sg_frontend_id}"
  alb_subnet_ids = "${module.m_base.subnet_public_ids}"
  vpc_id = "${module.m_alb.vpc_id}"  
}

module "m_ecs_cluster" {
  source          = "./cluster"
  stack_name   = "${module.m_base.stack_name}"
  environment  = "${module.m_base.environment}"
  
  cluster_name = "${var.cluster_name}"
  key_pair_name = "${var.key_pair_name}"
  instance_profile_name = "${aws_iam_instance_profile.ecs_instance.name}"
  security_group_ecs_instance_id = "${module.m_base.sg_internal_id}"
  ecs_cluster_subnet_ids = "${module.m_base.subnet_private_ids}"
  target_group_arn = "${module.m_alb.target_group_arn}"
}