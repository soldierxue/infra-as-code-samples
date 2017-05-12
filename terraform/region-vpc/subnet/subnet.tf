resource "aws_subnet" "main" {
  cidr_block = "${var.cidr_block_subnet}"
  vpc_id     = "${var.vpc_id}"
}

resource "aws_route_table" "main" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_route_table_association" "main" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}