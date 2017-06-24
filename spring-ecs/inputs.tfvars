region = "ap-northeast-1"

springAppNames = ["spring-config-server","spring-netflix-eureka-ha","spring-petclinic-rest-owner","spring-petclinic-rest-pet","spring-petclinic-rest-vet","spring-petclinic-rest-visit"]

# parameters for ecs cluster
stack_name = "springecs"
asg_min = "2"
asg_max = "10"
asg_desired_size = "2"
key_pair_name  = "ap-north1-key"