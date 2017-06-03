resource "aws_security_group" "frontend" {
  name        = "dmz-sg-${var.stack_name}"
  description = "Open access for Internet HTTP/SSH connection inbound"
  vpc_id      = "${var.vpc_id}"
  tags{
        Name = "sg-dmz-${var.stack_name}"
        Environment = "${var.environment}"  
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

}

resource "aws_security_group" "database" {
  name = "db-sg-${var.stack_name}"
  tags {
        Name = "sg-db-${var.stack_name}"
        Environment = "${var.environment}" 
  }
  description = "SG for db access from internal tcp CONNECTION INBOUND"
  vpc_id = "${var.vpc_id}"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.frontend.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group allowing internal traffic (inside VPC)
resource "aws_security_group" "internal" {
  vpc_id = "${var.vpc_id}"
  name = "internal-${var.stack_name}"
  description = "Allow internal traffic"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
        Name = "sg-internal-${var.stack_name}"
        Environment = "${var.environment}" 
  }
}

/*
  NAT Instance
*/
resource "aws_security_group" "natsg" {
    name = "vpc_nat-${var.stack_name}"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr_block}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr_block}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr_block}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${var.vpc_id}"

    tags {
        Name = "sg-nat-${var.stack_name}"
        Environment = "${var.environment}" 
    }
}