/*
 *  Samples to create a full vpc stack with public/private subnets & HA-NAT instances
 *  and the php website demo
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, roles for NAT instances
 *      (3) Scripts to monitor NAT instance healthy and update routes
 *      (4) PHP instance & backend MySQL instance
 *
 * Usage:
 *      git clone https://github.com/soldierxue/infra-as-code-samples
 *      cd ./infra-as-code-samples/bjs/phpdemo-full
 *      terraform get --update
 *      terraform plan
 *      terraform apply
 */
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

module "demophp" {
    source = "github.com/soldierxue/terraformlib/bjs-infra/demo-php"
    name ="${module.bjs-vpc.stack_name}"
    environment = "${module.bjs-vpc.environment}"
    vpc_id          = "${module.bjs-vpc.vpc_id}"
    public_subnet_id = "${module.bjs-vpc.subnet_public_ids[0]}"
    fronend_web_sgid = "${module.bjs-vpc.sg_frontend_id}"

    private_subnet_id = "${module.bjs-vpc.subnet_private_ids[0]}"
    database_sgid = "${module.bjs-vpc.sg_database_id}"

    ec2keyname = "bjsMyKey"
}
