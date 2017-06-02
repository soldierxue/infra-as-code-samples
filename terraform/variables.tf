### Basic Variables

variable "environment" {
    default="test"
    description = "Environment tag, e.g prod"
}

### For Code Commit
variable repo_name {
   default = "repo_cc"
   description = "The name of the code commit repository"
}

variable vpc_name {
   default = "vpc-jason"
   description = "The name of the vpc"
}



