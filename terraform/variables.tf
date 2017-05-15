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

variable "subnet_pub1_cidr"{
  type = "string"
  description = "The CIDR block for the public subnet1"
}
variable "subnet_pub2_cidr"{
  type = "string"
  description = "The CIDR block for the public subnet2"
}
variable "subnet_private1_cidr"{
  type = "string"
  description = "The CIDR block for the private subnet1"
}
variable "subnet_private2_cidr"{
  type = "string"
  description = "The CIDR block for the private subnet2" 
}

variable "ec2keyname"  {
  description = "key name to login to the ec2"
  type = "map"
}