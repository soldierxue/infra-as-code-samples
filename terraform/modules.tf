
# module to create code commit service
module "m_code_commit" {
  source          = "./code-commit"
  name          = "${var.repo_name}"
}

# module to create code commit service
module "m_global_vpc" {
  source          = "./global-vpc"
  name          = "${var.vpc_name}"
  environment  = "${var.environment}"
}