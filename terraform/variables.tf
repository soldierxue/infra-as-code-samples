variable "region" {
  type = "string"
  description = "the region where to create the VPC networking resources"
}

variable repo_name {
   default = "repo_cc"
   description = "The name of the code commit repository"
}

