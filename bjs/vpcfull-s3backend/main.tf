/*
 *  Samples to create a full vpc stack with public/private subnets & HA-NAT instances
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, roles for NAT instances
 *      (3) Scripts to monitor NAT instance healthy and update routes
 *
 *  This sample diff with "vpcfull" is that, here we try to store the terraform state in s3, by default
 *  terraform store state file in local file system
 *
 * Usage:
 *      git clone https://github.com/soldierxue/infra-as-code-samples
 *      cd ./infra-as-code-samples/bjs/vpcfull-s3backend
 *      terraform init
 *      terraform get --update
 *      
 *      terraform plan
 *      terraform apply
 */
terraform {
  backend "s3" {
    bucket = "terraform"
    key    = "network/terraform.tfstate"
    region = "cn-north-1"
  }
}

module "bjs-vpc" {
  source          = "github.com/soldierxue/terraformlib/bjs-infra"
  region          = "cn-north-1"
  base_cidr_block = "10.0.0.0/16"
  stack_name = "bjsdemo"
  environment = "test"
  ec2keyname = "bjsMyKey"
  keyfile = "~/bjsMyKey.pem"
  subnet_private_cidrs = ["10.0.48.0/20","10.0.112.0/20"]
  subnet_public_cidrs = ["10.0.0.0/20","10.0.16.0/20"]
}

output stack_name {
  value = "${module.bjs-vpc.stack_name}"
}
output environment {
  value = "${module.bjs-vpc.environment}"
}
output vpc_id {
  value = "${module.bjs-vpc.vpc_id}"
}

output subnet_private_ids {
  value = "${module.bjs-vpc.subnet_private_ids}"
}

output subnet_public_ids {
  value = "${module.bjs-vpc.subnet_public_ids}"
}

output private_route_ids {
  value = "${module.bjs-vpc.private_route_ids}"
}

output base_cidr_block {
  value = "${module.bjs-vpc.base_cidr_block}"
}

output sg_database_id {
  value = "${module.bjs-vpc.sg_database_id}"
}

output sg_frontend_id {
  value = "${module.bjs-vpc.sg_frontend_id}"
}

output sg_internal_id {
  value = "${module.bjs-vpc.sg_internal_id}"
}