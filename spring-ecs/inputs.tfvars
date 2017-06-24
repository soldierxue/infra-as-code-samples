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
dmz_alb_tg_names = ["tg_config","tg_eureka"]
dmz_alb_tg_protocals = ["HTTP","HTTP"]
dmz_alb_listener_port = "8761"
dmz_alb_rule_paths = ["config","eureka"]

# Internal ALB for Pet clinic related services
srv_alb_tg_names = ["tg_pet","tg_owner","tg_visit","tg_vet"]
srv_alb_tg_protocals = ["HTTP","HTTP","HTTP","HTTP"]
srv_alb_listener_port = "8080"
srv_alb_rule_paths = ["pet","owner","visit","vet"]