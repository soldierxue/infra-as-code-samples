provider "aws" {
  region = "ap-northeast-1"
}

## Required Variables

variable springAppNames {
   description = "The artificat names of spring micro services"
   type = "list"
}

module "ecr_regs" {
   source = "github.com/soldierxue/terraformlib/ecrs"
   names = ["${var.springAppNames}"]
}