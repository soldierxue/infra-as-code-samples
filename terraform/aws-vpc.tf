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