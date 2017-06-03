variable "region" {
  description = "The name of the AWS region to set up a network within"
}
# Data for AZs
data "aws_availability_zones" "all" {
}
variable "base_cidr_block" {}
variable "private_subnets_cidr"{type="list"}
variable "public_subnets_cidr"{type="list"}

##variable "ec2keyname"  {}

variable "DnsZoneName" {
  default = "jasondemo.internal"
  description = "the internal dns name"
}

