aws ecs list-clusters --region ap-northeast-1

{
    "clusterArns": [
        "arn:aws:ecs:ap-northeast-1:188869792837:cluster/ecs-jason-demo"
    ]
}

aws ecs list-services --cluster ecs-jason-demo --region ap-northeast-1

{
    "serviceArns": [
        "arn:aws:ecs:ap-northeast-1:188869792837:service/spring-hw-demo"
    ]
}

aws ecs register-task-definition --cli-input-json file://mnt/sdg/infra-as-code-samples/aws-cli/ecs/demo.json --region ap-northeast-1

aws ecs update-service --cluster ecs-jason-demo --service spring-hw-demo --desired-count 4 --task-definition spring-hw-demo:5 --region ap-northeast-1