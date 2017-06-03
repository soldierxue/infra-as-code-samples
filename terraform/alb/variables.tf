## The region option
variable "region" {
  type = "string"
  description = "the region where to create the VPC networking resources"
}

variable "stack_name" {
   default="jasonxue"
   description = "Stack name to separate different resources"
}
variable "name" {
   default="jasonxue"
   description = "ALB name for different services"
}
variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}
variable "port_listen" {
    default= "80"
    description = "The port for user access"
}
variable "port_forward" {
    default= "8080"
    description = "The port to forward to the backend service"
}
variable "security_group_internal_id" {
  description = "Id of security group allowing internal traffic"
}

variable "security_group_inbound_id" {
  description = "Id of security group allowing inbound traffic"
}

variable "alb_subnet_ids" {
  description = "list of subnets where ALB should be deployed"
  type = "list"
}

variable "vpc_id" {
  description = "Id of VPC where ALB will live"
}
