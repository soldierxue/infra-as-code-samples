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

# Init ECS Cluster parameters

cluster_name ="ecs-jason-demo"
ecs_instance_type = "t2.micro"
asg_min = "2"
asg_max = "4"

# Spring Hello World ECS Demo
service_name ="spring-hw-demo"
docker_image = "188869792837.dkr.ecr.us-east-1.amazonaws.com/jasonreg"
docker_tag = "spring-hw-1"
container_cpu = "500"
container_memory = "200"
container_port ="8080"
desired_count = "2"
