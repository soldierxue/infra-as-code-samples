variable "region" {
  description = "The name of the AWS region to set up a network within"
}

variable "base_cidr_block" {}

# Data for AZs
data "aws_availability_zones" "all" {
}

/*

provider "aws" {
  region = "${var.region}"
}
*/