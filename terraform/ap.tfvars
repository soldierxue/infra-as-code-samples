## The region option
region = "ap-northeast-1"

## The CIDR options
base_cidr_block ="10.0.0.0/16"
subnet_pub1_cidr="10.0.0.0/20"
subnet_pub2_cidr="10.0.16.0/20"
subnet_private1_cidr="10.0.48.0/20"
subnet_private2_cidr="10.0.112.0/20"

ec2keyname= {
  "ap-northeast-1" = "ap-north1-key"
  "us-west-1" = "uswest1key"
}

cluster_name ="ecs-jason-demo"
ecs_instance_type = "t2.micro"
asg_min = "1"
asg_max = "4"
