resource "aws_security_group" "frontend" {
  name        = "dmz-sg"
  description = "Open access for Internet HTTP/SSH connection inbound"
  vpc_id      = "${var.vpc_id}"
  tags{
     Name = "${format("sg-frontend-%s-%s", var.name, var.environment)}"
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
  name = "db-sg"
  tags {
        Name = "${format("sg-database-%s-%s", var.name, var.environment)}"
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
  name = "internal"
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
    Name = "${format("sg-internal-%s-%s", var.name, var.environment)}"
  }
}