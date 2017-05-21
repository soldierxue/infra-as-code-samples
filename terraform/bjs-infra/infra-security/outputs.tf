output "sg_database_id" {
  value = "${aws_security_group.database.id}"
}

output "sg_frontend_id" {
  value = "${aws_security_group.frontend.id}"
}

output "sg_internal_id" {
  value = "${aws_security_group.internal.id}"
}

output "sg_nat_id" {
  value = "${aws_security_group.natsg.id}"
}