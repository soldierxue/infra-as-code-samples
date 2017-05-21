resource "aws_instance" "nat1" {
    ami = "ami-0534fc68" # this is a special ami preconfigured to do NAT
    availability_zone = "${data.aws_availability_zones.all.names[0]}"
    instance_type = "m3.large"
    key_name = "${var.ec2_keyname}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${var.sg_nat_id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT1"
    }
}

resource "aws_eip" "nat1" {
    instance = "${aws_instance.nat1.id}"
    vpc = true
}

resource "aws_route_table" "rt-private" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat1.id}"
    }

    tags {
        Name = "NAT Route "
    }
}

resource "aws_route_table_association" "ass-rt-private" {
    subnet_id = "${var.private_subnet1_id}"
    route_table_id = "${aws_route_table.rt-private.id}"
}