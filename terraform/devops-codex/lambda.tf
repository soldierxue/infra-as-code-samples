resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "lambda_role_policy"
  role = "${aws_iam_role.iam_for_lambda.name}"
  
  policy = "${file("${path.module}/policies/lambda-policy.json")}"

  lifecycle { create_before_destroy = true }
}

resource "aws_lambda_function" "ecs-inplace-update" {
  filename         = "${path.module}/functions/ecs_inplace_update.py.zip"
  function_name    = "ecs-inplace-update"
  description = "Function for ECS service updates by policy:rolling, canary,etc"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "ecs_inplace_update.lambda_handler"
  source_code_hash = "${base64sha256(file("${path.module}/functions/ecs_inplace_update.py.zip"))}"
  runtime          = "python3.6"
  
  
  environment {
    variables = {
      ECS_REGION = "${var.ecs_region}"
      ECR_REGION = "${var.ecr_region}"
      ECR_REPO = "${var.ecr_repo}"
      ECS_CLUSTER = "${var.ecs_cluster}"
      SERVICE_NAME = "${var.ecs_service}"
      FAMILY_NAME = "${var.ecs_family_name}"
      ECS_TASK_CPU = "${var.ecs_task_cpu}"
      ECS_TASK_MEMORY = "${var.ecs_task_memory}"
      ECS_TASK_PORT = "${var.ecs_task_port}"
      DESIRED_COUNT = "${var.ecs_task_desiredcount}"
      MAX_HEALTHY_PERCENT ="${lookup(var.deployment_policy,"maximumPercent.${var.deployment_option}")}"
      MIN_HEALTH_PERCENT = "${lookup(var.deployment_policy,"minimumHealthyPercent.${var.deployment_option}")}"
    }
  }
}