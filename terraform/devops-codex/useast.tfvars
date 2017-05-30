## Options for ECS Deployment: InPlaceDoubling|InPlaceRolling
deployment_option="InPlaceDoubling"

ecr_region ="us-east-1"
ecr_rep = "jasonreg"
ecs_region = "ap-northeast-1"
ecs_cluster ="ecs-jason-demo"
ecs_service="spring-hw-demo"
ecs_task_cpu =200
ecs_task_memory =200
ecs_task_port=8080
ecs_task_desiredcount=4
codex_region = "us-east-1"
