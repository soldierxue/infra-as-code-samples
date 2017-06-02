resource "aws_vpc_dhcp_options" "mydhcp" {
    domain_name = "${var.name}.internal"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "${format("dhcp-%s-%s", var.name, var.environment)}"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${var.vpc_id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.mydhcp.id}"
}

/* DNS PART ZONE AND RECORDS */
resource "aws_route53_zone" "main" {
  name = "${var.name}.internal"
  vpc_id = "${var.vpc_id}"
  comment = "Route 53 Private Zone Managed by terraform"
}

resource "aws_route53_record" "database" {
   zone_id = "${aws_route53_zone.main.zone_id}"
   name = "${var.mysqlPrefix}.${var.name}.internal"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.database.private_ip}"]
}