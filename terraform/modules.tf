# For AWS Cloud
provider "aws" {
  region = "${var.region}"
}

module "m_code_commit" {
  source          = "./code-commit"
  name          = "${var.repo_name}"
}