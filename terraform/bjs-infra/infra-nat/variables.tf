# Data for AZs
data "aws_availability_zones" "all" {
}
variable ec2_keyname {}
variable sg_nat_id {}
variable vpc_id {}
variable private_subnet1_id {}
variable private_subnet2_id {}
