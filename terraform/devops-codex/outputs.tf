output "caller_account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "codepipeline_name_inplace" {
  value = "[${aws_codepipeline.spring-ecs-demo-inplaceupdate.name}]"
}
output "codepipeline_name_canary" {
  value = "[${aws_codepipeline.spring-ecs-demo-canary.name}]"
}