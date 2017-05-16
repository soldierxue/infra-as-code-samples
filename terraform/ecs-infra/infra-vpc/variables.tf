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

