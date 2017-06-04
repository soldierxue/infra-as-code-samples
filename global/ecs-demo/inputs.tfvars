stack_name = "ecsmydemo"
asg_min = "2"
asg_max = "10"
asg_desired_size = "4"
key_pair_name  = "ap-north1-key"

## variables for service and task
docker_tag = "LATEST"
container_cpu = "200"
container_memory = "300"
container_port = "8080"
task_desired_count ="1"