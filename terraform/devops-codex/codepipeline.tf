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
        RepositoryName   = "jasoncc"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "BuildJar"

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
  stage {
    name = "BuildImage"

    action {
      name             = "spring-docker"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["spring-build"]
      output_artifacts = ["spring-image"]
      version          = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.spring-docker.name}"
      }
    }
  }
  stage {
    count ="${lookup(var.deployment_policy,"countInplace.${var.deployment_option}")}"
    
    name = "InplaceUpdateECSTask"

    action {
      name             = "InplaceUpdate"
      category         = "Invoke"
      owner            = "AWS"
      provider         = "Lambda"
      input_artifacts  = ["spring-image"]
      version          = "1"
      configuration {
        FunctionName = "${aws_lambda_function.ecs-rollingupdate.function_name}"
      }
    }    
  }  
  stage {
    count ="${lookup(var.deployment_policy,"countCanary.${var.deployment_option}")}"
    
    name = "CanaryTestDeploy"

    action {
      name             = "CanaryTestDeploy"
      category         = "Invoke"
      owner            = "AWS"
      provider         = "Lambda"
      input_artifacts  = ["spring-image"]
      version          = "1"
      configuration {
        FunctionName = "${aws_lambda_function.ecs-rollingupdate.function_name}"
      }
    } 
  } 
  stage {
    count ="${lookup(var.deployment_policy,"countCanary.${var.deployment_option}")}"
    
    name = "CanaryApproval"

    action {
      name             = "GotoProductionApproval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
    } 
  }  
  stage {
    count ="${lookup(var.deployment_policy,"countCanary.${var.deployment_option}")}"
    
    name = "CanaryOnProductionDeploy"

    action {
      name             = "CanaryOnProductionDeploy"
      category         = "Invoke"
      owner            = "AWS"
      provider         = "Lambda"
      input_artifacts  = ["spring-image"]
      version          = "1"
      configuration {
        FunctionName = "${aws_lambda_function.ecs-rollingupdate.function_name}"
      }
    }
    action {
      name             = "RemoveCanaryService"
      category         = "Invoke"
      owner            = "AWS"
      provider         = "Lambda"
      input_artifacts  = ["spring-image"]
      version          = "1"
      configuration {
        FunctionName = "${aws_lambda_function.ecs-rollingupdate.function_name}"
      }
    }     
  }
 
}