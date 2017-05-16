# 此策略允许 Amazon CodeBuild Service 代表您调用 AWS

# An IAM role for codebuild service access
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"
  
  assume_role_policy = <<HEREDOC
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
   ]
  }
  HEREDOC

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy" "codebuild_role_policy" {
  name = "codebuild_role_policy"
  role = "${aws_iam_role.codebuild_role.name}"
  policy = "${file("${path.module}/policies/codebuild-policy.json")}"

  lifecycle { create_before_destroy = true }
}

# 此策略允许 Amazon CodeDeploy 代表您调用 AWS

# An IAM role for codedeploy service access
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role"
  
  assume_role_policy = <<HEREDOC
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
   ]
  }
  HEREDOC

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_policy" {
  role = "${aws_iam_role.codedeploy_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}


# 此策略允许 Amazon CodePipeline Service 代表您调用 AWS

# An IAM role for codebuild service access
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"
  
  assume_role_policy = <<HEREDOC
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
   ]
  }
  HEREDOC

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name = "codepipeline_role_policy"
  role = "${aws_iam_role.codepipeline_role.name}"
  policy = "${file("${path.module}/policies/codepipeline-policy.json")}"

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy_attachment"  role_att1{
  role = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_role_policy_attachment" role_att2 {
  role = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

resource "aws_iam_role_policy_attachment"  role_att3{
  role = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_role_policy_attachment"  role_att4{
  role = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}