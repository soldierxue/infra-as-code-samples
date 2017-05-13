# To Create a New VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.base_cidr_block}"
  enable_dns_hostnames = true
  tags {
        Name = "terraform-aws-vpc"
        Owner = "Jason"
  }
}

# To Create a IGW binding with the above VPC
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

# To Create a route table for ec2 in public subnet to access internet from IGW
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block =  "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
  }
}

# To Create a default route table
resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.main.id}"
}

# Definition for 4 Subnets: 2 public subnets/2 private subnets across two AZs
module "public_subnet1" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 0)}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
  route_tb_id = "${aws_route_table.public.id}"
}

module "public_subnet2" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 2)}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
  route_tb_id = "${aws_route_table.public.id}"
}

module "private_subnet2" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 1)}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
  route_tb_id = "${aws_route_table.default.id}"
}

module "private_subnet1" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 3)}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
  route_tb_id = "${aws_route_table.default.id}"
}

