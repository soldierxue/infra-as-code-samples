/*
 *  Samples to create a devops stack
 *  AWS Resources includes:
 *      (1) CodeCommit Repo
 *      (2) Elastic Container Registry 
 *      (3) CodePipeline, CodeBuild
 *      (4) Lambda
 */

provider "aws" {
  region = "ap-northeast-1"
}

module "code_commit" {
   source = "github.com/soldierxue/terraformlib/code-commit"
   name = "cc_demo_jason"
}

module "ecr_reg" {
   source = "github.com/soldierxue/terraformlib/ecr"
   name = "ecr_demo_jason"
}

module "code_ecs_demo" {
   source = "github.com/soldierxue/terraformlib/devops-codex"
   deployment_option="Canary"
   name = "ecs-jason3"
   ecr_region ="ap-northeast-1"
   ecr_repo = "${module.ecr_reg.ecr_name}"
   ecs_region = "ap-northeast-1"
   ecs_cluster ="ecs_cdemo"
   ecs_service="hw0603"
   ecs_task_cpu =200
   ecs_task_memory =200
   ecs_task_port=8080
   ecs_task_desiredcount=2
   codex_region = "ap-northeast-1"
   codecommit_repo = "${module.code_commit.repo_name}"
}