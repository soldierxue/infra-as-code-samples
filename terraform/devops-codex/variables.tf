provider "aws" {
  region = "us-east-1"
}

variable ecr_region{
   default = "us-east-1"
}

variable ecr_rep{
   default = "jasonreg"
}
variable ecs_region{
   default = "ap-northeast-1"
}
variable ecs_cluster{
   default = "ecs-jason-demo"
}
variable ecs_service{
   default = "spring-hw-demo"
}
variable ecs_task_cpu{
   default = 500
}
variable ecs_task_memory{
   default = 200
}
variable ecs_task_port{
   default = 8080
}

variable ecs_task_desiredcount{
   default = 4
}


variable ecr_repo{
  default = "jasonreg"
}


variable codex_region{
   default = "us-east-1"
}

data "aws_caller_identity" "current" {}

variable deployment_option {
   default = "InPlaceDoubling"
}

variable deployment_policy {
   type = "map"
   default = {
      maximumPercent.InPlaceDoubling = 200
      minimumHealthyPercent.InPlaceDoubling = 100
      maximumPercent.InPlaceRolling = 100
      minimumHealthyPercent.InPlaceRolling = 50
   }
}