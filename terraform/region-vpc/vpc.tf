# To Create a New VPC
resource "aws_vpc" "main" {
  cidr_block = "${cidrsubnet(var.base_cidr_block, 2, 1)}"
}

# To Create a IGW binding with the above VPC
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

# Data for AZs
data "aws_availability_zones" "all" {
}

# Definition for two Subnets
module "primary_subnet" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
}

module "secondary_subnet" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
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

