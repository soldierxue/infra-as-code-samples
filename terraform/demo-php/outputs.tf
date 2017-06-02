output "php-public-url" {
  value = "${aws_instance.phpapp.public_dns}"
}
output "php-ec2-keyname" {
  value = "${var.ec2keyname}"
}