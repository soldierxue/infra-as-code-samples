output "sg_database_id" {
  value = "${aws_security_group.database.id}"
}

output "sg_frontend_id" {
  value = "${aws_security_group.frontend.id}"
}

output "sg_internal_id" {
  value = "${aws_security_group.internal.id}"
}

output "ecs_instance_profile_name" {
  value = "${aws_iam_instance_profile.ecs_instance.name}"
}

output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs_service.arn}"
}

output "ecs_service_autoscale_role_arn" {
  value = "${aws_iam_role.ecs_service_autoscale.arn}"
}