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

output ecr_repo_url {
  value = "${module.ecr_reg.repository_url}"
}

output ecr_name {
  value = "${module.ecr_reg.name}"
}

output ecr_arn {
  value = "${module.ecr_reg.arn}"
}


output repo_clone_url_http {
  value = "${module.code_commit.clone_url_http}"
}

output repo_clone_url_ssh {
  value = "${module.code_commit.clone_url_ssh}"
}

output repo_name {
  value = "${module.code_commit.repository_name}"
}