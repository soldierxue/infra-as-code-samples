region = "ap-northeast-1"

springAppNames = ["spring-config-server","spring-netflix-eureka-ha","spring-petclinic-rest-owner","spring-petclinic-rest-pet","spring-petclinic-rest-vet","spring-petclinic-rest-visit"]

# parameters for ecs cluster
stack_name = "springecs"
ecs_cluster_name = "petcluster"
asg_min = "2"
asg_max = "10"
asg_desired_size = "2"
key_pair_name  = "ap-north1-key"

# parameters for ALB & target groups
# DMZ ALB for Config & Eureka Services
dmz_alb_tg_names = ["tg_config","tg_eureka","tg_eureka2"]
dmz_alb_tg_protocals = ["HTTP","HTTP","HTTP"]
dmz_alb_listener_port = "8761"
dmz_alb_rule_paths = ["config","eureka","eureka2"]

# Internal ALB for Pet clinic related services
srv_alb_tg_names = ["tg_pet","tg_owner","tg_visit","tg_vet"]
srv_alb_tg_protocals = ["HTTP","HTTP","HTTP","HTTP"]
srv_alb_listener_port = "8080"
srv_alb_rule_paths = ["pet","owner","visit","vet"]

# parameters for services and tasks
docker_tag = "LATEST"
container_cpu = "200"
container_memory = "300"
container_port = "8080"
task_desired_count ="1"


support_srv_params = {
      config.container_port = "7100"
      config.task_desired_count = "2"
      config.ecr_repo = "spring-config-server"
      config.service_name = "config_srv"
      config.family_name = "config_fname"
      config.tg_name = "tg_config" # mapping to find the target group arn

      eureka.container_port = "8761"
      eureka.task_desired_count = "1"
      eureka.ecr_repo = "spring-netflix-eureka-ha"
      eureka.service_name = "eureka_srv"
      eureka.family_name = "eureka_fname"
      eureka.tg_name = "tg_eureka" # mapping to find the target group arn   

      eureka2.container_port = "8761"
      eureka2.task_desired_count = "1"
      eureka2.ecr_repo = "spring-netflix-eureka-ha"
      eureka2.service_name = "eureka_srv2"
      eureka2.family_name = "eureka_fname2"
      eureka2.tg_name = "tg_eureka2" # mapping to find the target group arn              
}