# To Create a New VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.base_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
        Name = "terraform-aws-vpc"
        Owner = "Jason"
  }
}

# To Create a IGW binding with the above VPC
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
        Name = "terraform-aws-igw"
        Owner = "Jason"
  }
}


# To Create a route table for ec2 in public subnet to access internet from IGW
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block =  "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
        Name = "terraform-route-public-igw"
        Owner = "Jason"
  }  
}

# Definition for 4 Subnets: 2 public subnets/2 private subnets across two AZs
module "public_subnet1" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${var.subnet_pub1_cidr}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
  route_tb_id = "${aws_route_table.public.id}"
  subnet_name = "public_subnet1"
}

module "public_subnet2" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${var.subnet_pub2_cidr}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
  route_tb_id = "${aws_route_table.public.id}"
  subnet_name = "public_subnet2"
}

/*
 * For private subnet, create a route with NAT gateway for ec2 instances to access the internet
 */

# To Create a NAT Gateway

resource "aws_eip" "fornat" {
  vpc      = true 
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.fornat.id}"
  subnet_id     = "${module.public_subnet1.subnet_id}"
  depends_on = ["aws_internet_gateway.main","module.public_subnet1"] 
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block =  "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.natgw.id}"
  }
  tags {
        Name = "terraform-route-nat-public"
        Owner = "Jason"
  }    
}

module "private_subnet2" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${var.subnet_private1_cidr}"
  availability_zone = "${data.aws_availability_zones.all.names[0]}"
  route_tb_id = "${aws_route_table.private.id}"
  subnet_name = "private_subnet2"
}

module "private_subnet1" {
  source            = "./subnet"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block_subnet = "${var.subnet_private2_cidr}"
  availability_zone = "${data.aws_availability_zones.all.names[1]}"
  route_tb_id = "${aws_route_table.private.id}"
  subnet_name = "private_subnet1"
}