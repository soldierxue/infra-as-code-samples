## Options for ECS Deployment: InPlaceDoubling|InPlaceRolling|Canary
name = "ecs-demo-jason"
codex_region = "us-east-1"
deployment_option="Canary"

ecr_region ="us-east-1"
ecr_repo = "jasonreg"

ecs_region = "ap-northeast-1"
ecs_cluster ="ecs-jason-demo"
ecs_service="spring-hw-demo"
ecs_task_cpu =200
ecs_task_memory =200
ecs_task_port=8080
ecs_task_desiredcount=4


