### Basic Variables

## The region option
variable "region" {
  type = "string"
  description = "the region where to create the VPC networking resources"
}

variable stack_name {
   default = "global-stack"
   description = "The name of the stack"
}

variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}






