# For details, you can refer to http://docs.aws.amazon.com/zh_cn/AmazonECS/latest/developerguide/ecs_managed_policies.html#AmazonEC2ContainerServiceforEC2Role

# An IAM instance profile we attach to the EC2 instances in the cluster
# 此策略允许 Amazon ECS 容器实例代表您调用 AWS

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "ecs-instance"
  roles = ["${aws_iam_role.ecs_instance.name}"]

  lifecycle { create_before_destroy = true }
}

# An IAM role that we attach to the EC2 Instances in the cluster
resource "aws_iam_role" "ecs_instance" {
  name = "ecs-instance"
  assume_role_policy = "${file("${path.module}/policies/ecs-instance.json")}"

  lifecycle { create_before_destroy = true }
}

# IAM policy we add to ECS cluster instances that allows them to do their thing

resource "aws_iam_role_policy" "ecs_instance_policy" {
  name = "ecs-instance-policy"
  role = "${aws_iam_role.ecs_instance.id}"
  policy = "${file("${path.module}/policies/ecs-instance-policy.json")}"

  lifecycle { create_before_destroy = true }
}

# An IAM Role that we attach to ECS services
# 此策略允许 Elastic Load Balancing 负载均衡器代表您注册和取消注册 Amazon ECS 容器实例

resource "aws_iam_role" "ecs_service" {
  name = "ecs-service"
  assume_role_policy = "${file("${path.module}/policies/ecs-service.json")}"
}

# Managed IAM Policy for ECS services to communicate with EC2 Instances

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role = "${aws_iam_role.ecs_service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# An IAM Role for ECS service autoscaling
# 此策略允许 Application Auto Scaling 代表您增加和减少您的 Amazon ECS 服务的预期数量以响应 CloudWatch 警报

resource "aws_iam_role" "ecs_service_autoscale" {
  name = "ecs-service-autoscale"
  assume_role_policy = "${file("${path.module}/policies/ecs-service-autoscale.json")}"
}

# Managed IAM Policy for ECS service autoscaling

resource "aws_iam_role_policy_attachment" "ecs_service_autoscale" {
  role = "${aws_iam_role.ecs_service_autoscale.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}