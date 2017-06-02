# Data for AZs
data "aws_availability_zones" "all" {
}
variable "name" {
   default="vpc-terraform"
   description = "Name tag for vpc related resources"
}
variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}
variable "base_cidr_block" {
  type = "string"
  description = "the CIDR block for the VPC >= 16 <=28"
  default = "10.0.0.0/16"
}
variable "private_subnets_cidr"{
   type="list"
   description = "Subnets CIDR for private subnets"
   default = ["10.0.48.0/20","10.0.112.0/20"]
}
variable "public_subnets_cidr"{
   type="list"
   description = "Subnets CIDR for public subnets"
   default = ["10.0.0.0/20","10.0.16.0/20"]
}

