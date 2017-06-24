variable support_alb_tg_names {
   description = "The names of the target groups"
   type = "list"
} 
variable support_alb_tg_protocals {
   description = "The protocals for each target groups"
   type = "list"
} 
variable support_alb_rule_hosts {
   description = "The paths for different target groups within the same listener port"
   type = "list"
} 
variable support_alb_listener_port {
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
variable srv_alb_rule_hosts {
   description = "The hostnames for different target groups within the same listener port"
   type = "list"
} 
variable srv_alb_listener_port {
   description = "The port to which alb listener listen"
} 

# variables for dns
variable dns_zone_name {
   description = "The name for route53 host zone"
} 
variable dns_names {
   description = "The dns names"
   type = "list"
} 


module "support-alb" {
   source = "github.com/soldierxue/terraformlib/alb_tgs"
   name ="support-admin"
   stack_name="${module.apstack.stack_name}"
   environment = "${module.apstack.environment}"
   alb_is_internal = "0"
   alb_sgs = ["${module.apstack.sg_internal_id}","${module.apstack.sg_frontend_id}"]
   alb_subnet_ids = "${module.apstack.subnet_public_ids}"
   vpc_id = "${module.apstack.vpc_id}"
   alb_tg_names = ["${var.support_alb_tg_names}"]
   alb_tg_protocals = ["${var.support_alb_tg_protocals}"]
   alb_listener_port = "${var.support_alb_listener_port}"
   alb_rule_hosts = ["${var.support_alb_rule_hosts}"]
}

module "srv-alb" {
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
   alb_rule_hosts = ["${var.srv_alb_rule_hosts}"]
}

module "support-dns" {
	source = "github.com/soldierxue/terraformlib/dns"
	dns_zone_name = "${var.dns_zone_name}"
	dns_names = ["${var.dns_names}"]
	dns_cname_records = ["${module.support-alb.alb_public_url_withoutport}","${module.support-alb.alb_public_url_withoutport}","${module.support-alb.alb_public_url_withoutport}","${module.rv-alb.alb_public_url_withoutport}","${module.rv-alb.alb_public_url_withoutport}","${module.rv-alb.alb_public_url_withoutport}","${module.rv-alb.alb_public_url_withoutport}"]
}

