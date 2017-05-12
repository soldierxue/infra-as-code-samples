resource "aws_subnet" "main" {
  cidr_block = "${var.cidr_block_subnet}"
  vpc_id     = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
  tags {
        Name = "Terraform Subnet"
    }
}

resource "aws_route_table" "public" {
  count = "${igwcount == 1 ? 1 : 0}"
  vpc_id = "${var.vpc_id}"
  route {
        cidr_block =  "0.0.0.0/0"
        gateway_id = "${var.igwid}"
    }
}

resource "aws_route_table" "default" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_route_table_association" "main" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_route_table_association" "public" {
  depends_on = ["aws_route_table.public"]
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.public.id}"
}