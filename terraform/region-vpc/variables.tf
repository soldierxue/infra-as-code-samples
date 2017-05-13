variable "region" {
  description = "The name of the AWS region to set up a network within"
}

variable "base_cidr_block" {}

# Data for AZs
data "aws_availability_zones" "all" {
}

variable "subnet_pub1_cidr"{}
variable "subnet_pub2_cidr"{}
variable "subnet_private1_cidr"{}
variable "subnet_private2_cidr"{}

variable "DnsZoneName" {}

variable "ec2keyname" = {}
variable "mysqlPrefix"={}

data "aws_ami" "amazonlinux_ami" {
  most_recent      = true
  executable_users = ["self"]
  architecture  = "x86_64"

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*2017*"]
  }

  owners     = ["amazon"]
}