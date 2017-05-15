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

# model : demo for PHP app(public subnet) + MySql db(private subnet)

module "demo-php" {
  source          = "./demo-php"
  vpc_id          = "${module.aws-vpc.aws_vpc.main.id}"
  public_subnet_id = "${module.aws-vpc.aws_vpc.main.module.public_subnet1.subnet_id}"
  fronend_web_sgid = "${module.aws-vpc.aws_vpc.main.aws_security_group.frontend.id}"
  
  private_subnet_id = "${module.aws-vpc.aws_vpc.main.module.private_subnet1.subnet_id}"
  database_sgid = "${module.aws-vpc.aws_vpc.main.aws_security_group.database.id}"
  
  ec2keyname = "${var.ec2keyname}"
}

