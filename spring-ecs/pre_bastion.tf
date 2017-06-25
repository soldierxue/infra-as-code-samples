module "bastion" {
    source = "github.com/soldierxue/terraformlib/demo-php"
    name ="${module.apstack.stack_name}"
    environment = "${module.apstack.environment}"
    vpc_id          = "${module.apstack.vpc_id}"
    public_subnet_id = "${module.apstack.subnet_public_ids[0]}"
    fronend_web_sgid = "${module.apstack.sg_frontend_id}"

    private_subnet_id = "${module.apstack.subnet_private_ids[0]}"
    database_sgid = "${module.apstack.sg_database_id}"

    ec2keyname = "${var.key_pair_name}"
}