region = "ap-northeast-1"

code_pipeline_name_prefix="cp-mydemo"

ecr_region = "ap-northeast-1"
ecr_repo="ecr_demo_jason"

esc_cluster_name="ecs_cdemo"
ecs_service_name="hw0603"
ecs_family_name = "f_hw0603"


cc_repo="cc_demo_jason"
project_path = "spring-hw-1"

## Policy for service deployment: "InPlaceDoubling"|"InPlaceRolling"|"Canary"
service_deploy_policy = "Canary"