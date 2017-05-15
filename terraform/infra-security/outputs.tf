output "sg_database_id" {
  value = "${aws_security_group.database.id}"
}

output "sg_frontend_id" {
  value = "${aws_security_group.frontend.id}"
}
