data "template_file" "userdata_nat1" {
  template = "${file("${path.module}/user_data.tpl")}"

  vars {
    nat2_id = "${aws_instance.nat2.id}" #The instance ID of the NAT Node #2 instance that this script will be monitoring.
    nat2_rt_id = "${aws_route_table.rt-private-nat2.id}" #The ID of the route table routing Internet-bound traffic through the NAT Node #2 instance that this script will be monitoring.
    nat1_rt_id = "${aws_route_table.rt-private-nat1.id}" #The ID of the route table routing Internet-bound traffic through this instance, NAT Node #1.
    num_pings = 3 #This is the number of times the health check will ping NAT Node #2. The default is 3 pings. NAT Node #2 will only be considered unhealthy if all pings fail.
    ping_timeout = 1 # The number of seconds to wait for each ping response before determining that the ping has failed. The default is one second.
    wait_between_pings = 2 #The number of seconds to wait between health checks. The default is two seconds. Therefore, by default, the health check will perfrom 3 pings with 1 second timeouts and a 2 second break between checks -- resulting in a total time of 5 seconds between each aggregete health check.
    wait_for_instance_stop = 60 #The number of seconds to wait for NAT Node #2 to stop before attempting to stop it again (if it hasn't stopped already). The default is 60 seconds.
    wait_for_instance = 300 #The number of seconds to wait for NAT Node #2 to restart before resuming health checks again. The default is 300 seconds.
    
  }
}

data "template_file" "userdata_nat2" {
  template = "${file("${path.module}/user_data.tpl")}"

  vars {
    nat2_id = "${aws_instance.nat1.id}"
    nat2_rt_id = "${aws_route_table.rt-private-nat1.id}"
    nat1_rt_id = "${aws_route_table.rt-private-nat2.id}"
    num_pings = 3 
    wait_between_pings = 2 
    wait_for_instance_stop = 60 
    wait_for_instance = 300   
  }
}

# Resources for NAT Node 1

resource "aws_instance" "nat1" {
    ami = "ami-0534fc68" # this is a special ami preconfigured to do NAT
    iam_instance_profile = "${var.instance_profile_name}"
    availability_zone = "${data.aws_availability_zones.all.names[0]}"
    instance_type = "m3.large"
    key_name = "${var.ec2_keyname}"
    vpc_security_group_ids = ["${var.sg_nat_id}"]
    subnet_id = "${var.public_subnet1_id}"
    associate_public_ip_address = true
    source_dest_check = false
    user_data = "${data.template_file.userdata_nat1.rendered}"

    tags {
        Name = "VPC NAT1"
    }
}

resource "aws_eip" "nat1" {
    instance = "${aws_instance.nat1.id}"
    vpc = true
}

resource "aws_route_table" "rt-private-nat1" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat1.id}"
    }

    tags {
        Name = "NAT Route 1"
    }
}

resource "aws_route_table_association" "ass-rt-private-1" {
    subnet_id = "${var.private_subnet1_id}"
    route_table_id = "${aws_route_table.rt-private-nat1.id}"
}

# Resources for NAT Node 2

resource "aws_instance" "nat2" {
    ami = "ami-0534fc68" # this is a special ami preconfigured to do NAT
    iam_instance_profile = "${var.instance_profile_name}"
    availability_zone = "${data.aws_availability_zones.all.names[1]}"
    instance_type = "m3.large"
    key_name = "${var.ec2_keyname}"
    vpc_security_group_ids = ["${var.sg_nat_id}"]
    subnet_id = "${var.public_subnet2_id}"
    associate_public_ip_address = true
    source_dest_check = false
    user_data = "${data.template_file.userdata_nat2.rendered}"

    tags {
        Name = "VPC NAT2"
    }
}

resource "aws_eip" "nat2" {
    instance = "${aws_instance.nat2.id}"
    vpc = true
}

resource "aws_route_table" "rt-private-nat2" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat2.id}"
    }

    tags {
        Name = "NAT Route 2"
    }
}

resource "aws_route_table_association" "ass-rt-private-2" {
    subnet_id = "${var.private_subnet2_id}"
    route_table_id = "${aws_route_table.rt-private-nat2.id}"
}