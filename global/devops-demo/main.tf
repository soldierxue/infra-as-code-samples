/*
 *  Samples to create a devops stack
 *  AWS Resources includes:
 *      (1) CodeCommit Repo
 *      (2) Elastic Container Registry 
 *      (3) CodePipeline, CodeBuild
 *      (4) Lambda
 */
## Required Variables

variable region {
   description = "The region for which AWS resources will be created"
}
variable ecr_region {
   description = "The region for ECR, so we support ecr from different region with codepipeline"
}

variable code_pipeline_name_prefix {
   description = "The name prefix for the code*, to separate different pipelines"
}

variable ecr_repo {
   description = "The name of the Docker image registry"
}

variable esc_cluster_name {
   description = "The name of the ECS cluster"
}

variable ecs_service_name {
   description = "The name of the service, it is the same with task family name in this demo"
}
variable ecs_family_name {
   description = "The faimil name of ecs task"
}
variable cc_repo {
   description = "The name of code commit repository"
}

variable service_deploy_policy {
   description = "policy for how to update ecs services in the cluster"
   default = "InPlaceDoubling"
}
variable project_path {
   description = "project name to be built and deployed"
}


provider "aws" {
  region = "${var.region}"
}

module "code_ecs_demo" {
   source = "github.com/soldierxue/terraformlib/devops-codex"
   name = "${var.code_pipeline_name_prefix}"
   ecr_region ="${var.ecr_region}"
   ecr_repo = "${var.ecr_repo}"
   ecs_region = "${var.region}"
   ecs_cluster ="${var.esc_cluster_name}"
   ecs_service="${var.ecs_service_name}"
   deployment_option="${var.service_deploy_policy}"
   #ecs_task_cpu =200
   #ecs_task_memory =200
   #ecs_task_port=8080
   #ecs_task_desiredcount=2
   codex_region = "${var.region}"
   codecommit_repo = "${var.cc_repo}"
}