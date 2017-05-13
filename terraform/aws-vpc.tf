# variables

## The region option
variable "region" {
  type = "string"
  description = "the region where to create the VPC networking resources"
  default = "us-west-1"
}

## The VPC CIDR option
variable "base_cidr_block" {
  default = "10.0.0.0/16"
  type = "string"
  description = "the CIDR block for the VPC >= 16 <=28"  
}

variable "subnet_pub1_cidr"{
  # default = "${cidrsubnet(var.base_cidr_block, 4, 0)}"
  default = "10.0.0.0/20"
  type = "string"
  description = "The CIDR block for the public subnet1"
}
variable "subnet_pub2_cidr"{
  # default = "${cidrsubnet(var.base_cidr_block, 4, 2)}"
  default="10.0.16.0/20"
  type = "string"
  description = "The CIDR block for the public subnet2"
}
variable "subnet_private1_cidr"{
  # default = "${cidrsubnet(var.base_cidr_block, 4, 1)}"
  default="10.0.48.0/20"
  type = "string"
  description = "The CIDR block for the private subnet1"
}
variable "subnet_private2_cidr"{
  # default = "${cidrsubnet(var.base_cidr_block, 4, 3)}"
  default="10.0.112.0/20"
  type = "string"
  description = "The CIDR block for the private subnet2" 
}

variable "DnsZoneName" {
  default = "jasondemo.internal"
  description = "the internal dns name"
}

variable "mysqlPrefix" {
  default = "mysqldb"
  description = "the prefix name for mysql server"
}

variable "ec2keyname"  {
  default = "uswest1key"
  description = "key name to login to the ec2"
  type = "string"
}

# models VPC

module "aws-vpc" {
  source          = "./region-vpc"
  region          = "${var.region}"
  base_cidr_block = "${var.base_cidr_block}"
}

# For AWS Cloud
provider "aws" {
  region = "${var.region}"
}