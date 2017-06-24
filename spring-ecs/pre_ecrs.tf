
## Required Variables

variable region {
   description = "The region for which AWS resources will be created"
}

variable springAppNames {
   description = "The artificat names of spring micro services"
   type = "list"
}

provider "aws" {
  region = "${var.region}"
}

module "ecr_regs" {
   source = "github.com/soldierxue/terraformlib/ecrs"
   names = ["${var.springAppNames}"]
}