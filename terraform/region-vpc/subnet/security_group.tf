resource "aws_security_group" "az" {
  name        = "az-${data.aws_availability_zone.target.name}-${aws_subnet.main.id}"
  description = "Open access within the AZ ${data.aws_availability_zone.target.name}"
  vpc_id      = "${var.vpc_id}"
  tags{
     Name = "terraform-sg"
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.main.cidr_block}"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${aws_subnet.main.cidr_block}"]
  }  

}