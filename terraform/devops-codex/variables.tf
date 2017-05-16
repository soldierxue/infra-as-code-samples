provider "aws" {
  region = "us-east-1"
}

variable ecr_region{
   default = "us-east-1"
}
variable codex_region{
   default = "us-east-1"
}

variable ecr_repo{
  default = "jasonreg"
}
variable aws_accountid {}