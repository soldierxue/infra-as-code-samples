resource "aws_s3_bucket" "spring-pipeline" {
  bucket = "devops-jason"
  acl    = "private"
}

resource "aws_codepipeline" "spring-ecs-demo" {  
  name     = "spring-ecs-demo"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.spring-pipeline.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "codecommit-checkout"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["spring-source"]

      configuration {
        Owner      = "jason-aws"
        Repo       = "jasoncc"
        Branch     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "spring-compile"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["spring-source"]
      output_artifacts = ["spring-build"]
      version          = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.spring-ecs-jar.name}"
      }
    }
  }
}