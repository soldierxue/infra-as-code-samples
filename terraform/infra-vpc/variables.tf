variable "region" {
  description = "The name of the AWS region to set up a network within"
}
# Data for AZs
data "aws_availability_zones" "all" {
}
variable "base_cidr_block" {}
variable "subnet_pub1_cidr"{}
variable "subnet_pub2_cidr"{}
variable "subnet_private1_cidr"{}
variable "subnet_private2_cidr"{}
variable "ec2keyname"  {}


data "aws_ami" "amazonlinux_ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*2017*x86_64*ebs*"]
  }

  owners     = ["amazon"]
}


###
### Demo: PHPAPP(public subnet) + MySQL(private subnet)
###
variable "DnsZoneName" {
  default = "jasondemo.internal"
  description = "the internal dns name"
}

variable "mysqlPrefix" {
  default = "mysqldb"
  description = "the prefix name for mysql server"
}

