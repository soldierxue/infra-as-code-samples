resource "aws_security_group" "frontend" {
  name        = "dmz-sg"
  description = "Open access for Internet HTTP/SSH connection inbound"
  vpc_id      = "${var.vpc_id}"
  tags{
     Name = "terraform-sg-dmz"
     Owner = "Jason"
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
        Name = "terraform-sg-database"
        Owenr = "Jason"
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