output "php-public-url" {
  value = "${${aws_instance.database.public_dns}}"
}