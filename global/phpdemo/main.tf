/*
 *  Samples to create a full vpc stack  with public/private subnets & NAT Gateways for private subnets
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, 
 *      (3) NAT Gateways
 *      (4) PHP Demo to verify the backend networking infra
 */
provider "aws" {
  region = "us-east-2"
}

terraform {
  backend  "s3" {
    bucket = "[replace_with_you_bucket_name]"
    key    = "network/terraform.tfstate"
    region = "us-east-2"
  }
}

module "apstack" {
    source = "github.com/soldierxue/terraformlib"
    stack_name = "jasonstack"
}

module "demophp" {
    source = "github.com/soldierxue/terraformlib/demo-php"
    name ="${module.apstack.stack_name}"
    environment = "${module.apstack.environment}"
    vpc_id          = "${module.apstack.vpc_id}"
    public_subnet_id = "module.apstack.subnet_public_ids[0]"
    fronend_web_sgid = "${module.apstack.sg_frontend_id}"

    private_subnet_id = "module.apstack.subnet_private_ids[0]"
    database_sgid = "${module.apstack.sg_database_id}"

    ec2keyname = "[replace_with_your_key_pairname]"
}