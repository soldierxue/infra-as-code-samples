resource "aws_codebuild_project" "spring-ecs-jar" {  
  name         = "spring-jar"
  description  = "builds spring-ecs jar file"
  build_timeout      = "10" # in minutes
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/java:openjdk-8"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "${file("${path.module}/buildspecs/spring-jar.yml")}"
  }

  tags {
    "Environment" = "dev"
  }
}

resource "aws_codebuild_project" "spring-docker" {  
  name         = "spring-ecs-image"
  description  = "builds spring-ecs docker image file"
  build_timeout      = "10" # in minutes
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:1.12.6"
    type         = "LINUX_CONTAINER"
    environment_variable {
      "name"  = "ECR_REGION"
      "value" = "${var.ecr_region}"
    }
    environment_variable {
      "name"  = "ECR_REPO_URI"
      "value" = "${var.aws_accountid}.dkr.ecr.${var.ecr_region}.amazonaws.com/${var.ecr_repo}"
    }    
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "${file("${path.module}/buildspecs/spring-image.yml")}"
  }

  tags {
    "Environment" = "dev"
  }
}