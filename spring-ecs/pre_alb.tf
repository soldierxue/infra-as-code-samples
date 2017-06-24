variable dmz_alb_tg_names {
   description = "The names of the target groups"
   type = "list"
} 
variable dmz_alb_tg_protocals {
   description = "The protocals for each target groups"
   type = "list"
} 
variable dmz_alb_rule_paths {
   description = "The paths for different target groups within the same listener port"
   type = "list"
} 
variable dmz_alb_listener_port {
   description = "The port to which alb listener listen"
} 

variable srv_alb_tg_names {
   description = "The names of the target groups"
   type = "list"
} 
variable srv_alb_tg_protocals {
   description = "The protocals for each target groups"
   type = "list"
} 
variable srv_alb_rule_paths {
   description = "The paths for different target groups within the same listener port"
   type = "list"
} 
variable srv_alb_listener_port {
   description = "The port to which alb listener listen"
} 

module "dmz-alb" {
   source = "github.com/soldierxue/terraformlib/alb_tgs"
   name ="dmz-admin"
   stack_name="${module.apstack.stack_name}"
   environment = "${module.apstack.environment}"
   alb_is_internal = "0"
   alb_sgs = ["${module.apstack.sg_internal_id}","${module.apstack.sg_frontend_id}"]
   alb_subnet_ids = "${module.apstack.subnet_public_ids}"
   vpc_id = "${module.apstack.vpc_id}"
   alb_tg_names = ["${var.dmz_alb_tg_names}"]
   alb_tg_protocals = ["${var.dmz_alb_tg_protocals}"]
   alb_listener_port = "${var.dmz_alb_listener_port}"
   alb_rule_paths = ["${var.dmz_alb_rule_paths}"]
}

module "internal-alb" {
   source = "github.com/soldierxue/terraformlib/alb_tgs"
   name ="pet-alb"
   stack_name="${module.apstack.stack_name}"
   environment = "${module.apstack.environment}"
   alb_sgs = ["${module.apstack.sg_internal_id}"]
   alb_subnet_ids = "${module.apstack.subnet_private_ids}"
   vpc_id = "${module.apstack.vpc_id}"
   alb_tg_names = ["${var.srv_alb_tg_names}"]
   alb_tg_protocals = ["${var.srv_alb_tg_protocals}"]
   alb_listener_port = "${var.srv_alb_listener_port}"
   alb_rule_paths = ["${var.srv_alb_rule_paths}"]
}