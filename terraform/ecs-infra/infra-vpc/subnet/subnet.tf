resource "aws_subnet" "main" {
  cidr_block = "${var.cidr_block_subnet}"
  vpc_id     = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
  tags {
        Name = "${var.subnet_name}"
        Owner = "Jason"
    }
}

resource "aws_route_table_association" "main" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${var.route_tb_id}"
}