# To Create a New VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.base_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
        Name = "${var.name}"
        Environment = "${var.environment}"
  }
}


# To Create a IGW binding with the above VPC
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
        Name = "igw-${var.name}"
        Environment = "${var.environment}"
  }
}


# To Create a route table for ec2 in public subnet to access internet from IGW
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block =  "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
        Name = "route-table-${var.name}"
        Environment = "${var.environment}"
  }  
}

resource "aws_subnet" "public" {
  count = "${length(data.aws_availability_zones.all.names)}"
  
  cidr_block = "${element(var.public_subnets_cidr, count.index)}"
  vpc_id     = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.all.names[count.index]}"
  tags {
        Name = "pub subnet#${count.index+1}-${var.name}"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "public" {
  count = "${length(data.aws_availability_zones.all.names)}"
   
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

/*
 * For private subnet, by default instances within it can't acess internat
 */

# To Create a route table for ec2 in private subnet to access internet from IGW
resource "aws_route_table" "private" {
  count = "${length(data.aws_availability_zones.all.names)}"
 
  vpc_id = "${aws_vpc.main.id}"
  tags {
        Name = "route-private #${count.index}-${var.name}"
        Environment = "${var.environment}"
  }  
}

resource "aws_subnet" "private" {
  count = "${length(data.aws_availability_zones.all.names)}"
  
  cidr_block = "${element(var.private_subnets_cidr, count.index)}"
  vpc_id     = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.all.names[count.index]}"
  tags {
        Name = "private subnet #${count.index+1}-${var.name}"
        Environment = "${var.environment}"
    }
}

resource "aws_route_table_association" "private" {
  count = "${length(data.aws_availability_zones.all.names)}"
   
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id,count.index)}"
}