output "caller_account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "codepipeline_names" {
  value = "[${aws_codepipeline.*.name}]"
}