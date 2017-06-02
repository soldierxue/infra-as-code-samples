output "ecs_instance_profile_name" {
  value = "${aws_iam_instance_profile.ecs_instance.name}"
}

output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs_service.arn}"
}

output "ecs_service_autoscale_role_arn" {
  value = "${aws_iam_role.ecs_service_autoscale.arn}"
}

output "cluster_name" {
  value = "${module.m_ecs_cluster.cluster_name}"
}