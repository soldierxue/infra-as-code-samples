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

## Variables for ECS Cluster

variable "cluster_name"{
  type = "string"
  description = "The name of the ecs cluster" 
}

variable "asg_min"{
  type = "string"
  description = "The minimal number of the ASG group" 
}
variable "asg_max"{
  type = "string"
  description = "The max number of instances of the ASG group" 
}
variable "ecs_instance_type"{
  type = "string"
  description = "The instance type of the ecs instance" 
}
