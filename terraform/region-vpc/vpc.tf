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

# Definition for two Subnets
module "public_subnet" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 0)}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
  igwid = "${aws_internet_gateway.main.id}"
}

module "public_subnet" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 2)}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
  igwid = "${aws_internet_gateway.main.id}"
}

module "private_subnet" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 1)}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
}

module "private_subnet" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${cidrsubnet(var.base_cidr_block, 4, 3)}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
}

# SGs definition
resource "aws_security_group" "region" {
  name        = "region"
  description = "Open access within this region"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }
}

resource "aws_security_group" "internal-all" {
  name        = "internal-all"
  description = "Open access within the full internal network"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.base_cidr_block}"]
  }
}

