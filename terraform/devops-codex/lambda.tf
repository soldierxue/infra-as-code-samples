resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda-${var.name_codepipeline_prefix}"

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
  name = "lambda_role_policy-${var.name_codepipeline_prefix}"
  role = "${aws_iam_role.iam_for_lambda.name}"
  
  policy = "${file("${path.module}/policies/lambda-policy.json")}"

  lifecycle { create_before_destroy = true }
}



resource "aws_lambda_function" "ecs-inplace-update" {
  filename         = "${path.module}/functions/ecs_inplace_update.py.zip"
  function_name    = "ecs-inplace-update"
  description = "Function for ECS service updates by policy:rolling update or doubling update etc"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "ecs_inplace_update.lambda_handler"
  source_code_hash = "${base64sha256(file("${path.module}/functions/ecs_inplace_update.py.zip"))}"
  runtime          = "python3.6"
  publish = true 
  timeout = 180
  
  environment {
    variables = {
      ECS_REGION = "${var.ecs_region}"
      ECR_REGION = "${var.ecr_region}"
      ECS_CLUSTER = "${var.ecs_cluster}"
      SERVICE_NAME = "${var.ecs_service}"
      FAMILY_NAME = "${var.ecs_family_name}"
      DESIRED_COUNT = "${var.ecs_task_desiredcount}"
      MAX_HEALTHY_PERCENT ="${lookup(var.deployment_policy,"maximumPercent.${var.deployment_option}")}"
      MIN_HEALTH_PERCENT = "${lookup(var.deployment_policy,"minimumHealthyPercent.${var.deployment_option}")}"
    }
  }
}

resource "aws_lambda_function" "ecs-canary-update" {
  filename         = "${path.module}/functions/ecs_canary_update.py.zip"
  function_name    = "ecs-canary-update"
  description = "Function for ECS service updates by policy: canary,etc"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "ecs_canary_update.lambda_handler"
  source_code_hash = "${base64sha256(file("${path.module}/functions/ecs_canary_update.py.zip"))}"
  runtime          = "python3.6"
  publish = true 
  timeout = 180
  
  environment {
    variables = {
      ECS_REGION = "${var.ecs_region}"
      ECR_REGION = "${var.ecr_region}"
      ECS_CLUSTER = "${var.ecs_cluster}"
      SERVICE_NAME = "${var.ecs_service}"
      FAMILY_NAME = "${var.ecs_family_name}"
      CANARY_SUFFIX = "${lookup(var.deployment_policy,"suffix.${var.deployment_option}")}"
      MAX_HEALTHY_PERCENT ="${lookup(var.deployment_policy,"maximumPercent.${var.deployment_option}")}"
      MIN_HEALTH_PERCENT = "${lookup(var.deployment_policy,"minimumHealthyPercent.${var.deployment_option}")}"
    }
  }
}