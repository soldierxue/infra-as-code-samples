# Data for AZs
data "aws_availability_zones" "all" {
}
variable ec2_keyname {}
variable sg_nat_id {}
variable vpc_id {}
variable private_subnet1_id {}
variable private_subnet2_id {}
variable private_subnets {
   default = [
     "${var.private_subnet1_id}",
     "${var.private_subnet2_id}"
   ]
}
variable public_subnet1_id {}
variable public_subnet2_id {}
variable public_subnets {
   default =[
     "${var.public_subnet1_id}",
     "${var.public_subnet2_id}"
   ]
}
variable instance_profile_name {}
variable aws_region {}
variable nat_monitor_num_pings {
   default=3
}
variable nat_monitor_ping_timeout {
   default=1
}
variable nat_monitor_wait_between_pings {
    default=2
}
variable nat_monitor_wait_for_instance_stop {
    default=60
}
variable nat_monitor_wait_for_instance_start {
    default=300
}