output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet1_id" {
  value = "${module.public_subnet1.subnet_id}"
}
output "public_subnet2_id" {
  value = "${module.public_subnet2.subnet_id}"
}

output "private_subnet1_id" {
  value = "${module.private_subnet1.subnet_id}"
}

output "private_subnet2_id" {
  value = "${module.private_subnet2.subnet_id}"
}