variable vpc_id {}
variable vpc_cidr_block{}
variable "stack_name"{
  type = "string"
  description = "the name of the stack"  
}
variable "environment"{
  type = "string"
  description = "the purpose of the stack,like prod,test,pilot,etc"  
}