/**
 * The code commit module aims to create a code commit repo when needed
 *
 * Usage:
 *
 *    module "m_code_commit" {
 *      source      = "github.com/soldierxue/infra-as-code-samples/terraform/code-commit"
 *      name        = "my-repo"
 *    }
 *
 */

variable name {
   default ="cm-repo"
}


resource "aws_codecommit_repository" "cm-repo" {
  repository_name = "${var.name}"
  description     = "Sample CodeCommit Repository"
  default_branch = "master"
}

output repo_clone_url_http {
  value = "${aws_codecommit_repository.cm-repo.clone_url_http}"
}

output repo_clone_url_ssh {
  value = "${aws_codecommit_repository.cm-repo.clone_url_ssh}"
}

output repo_name {
  value = "${aws_codecommit_repository.cm-repo.repository_name}"
}
