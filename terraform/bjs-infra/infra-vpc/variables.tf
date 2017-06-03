variable "region" {
  description = "The name of the AWS region to set up a network within"
}
# Data for AZs
data "aws_availability_zones" "all" {
}

variable "base_cidr_block" {}
variable "private_subnets_cidr"{type="list"}
variable "public_subnets_cidr"{type="list"}

variable "stack_name"{
  type = "string"
  description = "the name of the stack"  
}
variable "environment"{
  type = "string"
  description = "the purpose of the stack,like prod,test,pilot,etc"  
}

variable "DnsZoneName" {
  default = "jasondemo.internal"
  description = "the internal dns name"
}

