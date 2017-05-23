output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet1_id" {
  value = "${aws_subnet.public.*.id[0]}"
}

output "public_subnet2_id" {
  value = "${aws_subnet.public.*.id[1]}"
}

output "private_subnet1_id" {
  value = "${aws_subnet.private.*.id[0]}"
}

output "private_subnet2_id" {
  value = "${aws_subnet.private.*.id[1]}"
}

output "subnet_private_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "subnet_public_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_route_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "private_route1_id" {
  value = "${aws_route_table.private.*.id[0]}"
}
output "private_route2_id" {
  value = "${aws_route_table.private.*.id[1]}"
}
