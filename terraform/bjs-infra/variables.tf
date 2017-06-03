## The region option
variable "region" {
  type = "string"
  description = "the region where to create the VPC networking resources"
}

## The VPC CIDR option
variable "base_cidr_block" {
  type = "string"
  description = "the CIDR block for the VPC >= 16 <=28"  
}
variable "subnet_private_cidrs"{
  type = "list"
  description = "The CIDR block for the private subnets" 
}
variable "subnet_public_cidrs"{
  type = "list"
  description = "The CIDR block for the public subnets" 
}
variable "ec2keyname"  {
  description = "key name to login to the ec2"
}