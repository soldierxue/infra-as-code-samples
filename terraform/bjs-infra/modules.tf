# For AWS Cloud
provider "aws" {
  region = "${var.region}"
}

# models VPC
module "aws-vpc" {
  source          = "./infra-vpc"
  region          = "${var.region}"
  base_cidr_block = "${var.base_cidr_block}"
  ##ec2keyname = "${var.ec2keyname}"
  private_subnets_cidr = ["${var.subnet_private_cidrs}"]
  public_subnets_cidr = ["${var.subnet_public_cidrs}"]
}

# model: securities like Security Groups, IAM roles

module "securities" {
  source          = "./infra-security"
  vpc_id          = "${module.aws-vpc.vpc_id}"
  vpc_cidr_block  = "${var.base_cidr_block}"
}

# model: NAT Gateway instances

module "natgateways" {
  source          = "./infra-nat"
  vpc_id          = "${module.aws-vpc.vpc_id}"
  public_subnets = ["${module.aws-vpc.subnet_public_ids}"]
  private_subnets = ["${module.aws-vpc.subnet_private_ids}"]
  private_routes = ["${module.aws-vpc.private_route_ids}"]
  #public_subnets = ["${module.aws-vpc.public_subnet1_id}","${module.aws-vpc.public_subnet2_id}"]
  #private_subnets = ["${module.aws-vpc.private_subnet1_id}","${module.aws-vpc.private_subnet2_id}"]
  #private_routes = ["${module.aws-vpc.private_route1_id}","${module.aws-vpc.private_route2_id}"]
  sg_nat_id ="${module.securities.sg_nat_id}"
  ec2_keyname = "${var.ec2keyname}"
  instance_profile_name = "${module.securities.role_nat_profile_name}"
  aws_region = "${var.region}"
}