# For AWS Cloud
provider "aws" {
  region = "${var.region}"
}

# models VPC

module "aws-vpc" {
  source          = "./infra-vpc"
  region          = "${var.region}"
  base_cidr_block = "${var.base_cidr_block}"
  ec2keyname = "${var.ec2keyname}"
  subnet_private2_cidr = "${var.subnet_private2_cidr}"
  subnet_private1_cidr = "${var.subnet_private1_cidr}"
  subnet_pub2_cidr = "${var.subnet_pub2_cidr}"
  subnet_pub1_cidr = "${var.subnet_pub1_cidr}"
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
  private_subnet1_id  = "${var.subnet_private1_cidr}"
  private_subnet2_id = "${var.subnet_private2_cidr}"
  public_subnet1_id  = "${var.subnet_pub1_cidr}"
  public_subnet2_id = "${var.subnet_pub2_cidr}"
  sg_nat_id ="${module.securities.sg_nat_id}"
  ec2_keyname = "${var.ec2keyname["${var.region}"]}"
  instance_profile_name = "${module.securities.role_nat_profile_name}"
}

# model : demo for PHP app(public subnet) + MySql db(private subnet)

module "demo-php" {
  source          = "./demo-php"
  vpc_id          = "${module.aws-vpc.vpc_id}"
  public_subnet_id = "${module.aws-vpc.public_subnet1_id}"
  fronend_web_sgid = "${module.securities.sg_frontend_id}"
  
  private_subnet_id = "${module.aws-vpc.private_subnet1_id}"
  database_sgid = "${module.securities.sg_database_id}"
  
  ec2keyname = "${var.ec2keyname["${var.region}"]}"
}


