variable "name" {
   default="jasonxue"
   description = "Name tag for resources"
}
variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}
variable vpc_id {}
variable vpc_cidr_block{}
