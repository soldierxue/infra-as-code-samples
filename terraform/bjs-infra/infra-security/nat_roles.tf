# An IAM instance profile we attach to the NAT EC2 instances 
# 此策略允许 Amazon EC2 NAT 实例代表您调用 AWS

resource "aws_iam_instance_profile" "nat_profile" {
  name = "nat-profile"
  role = "${aws_iam_role.nat_assume_role.name}"

  lifecycle { create_before_destroy = true }
}

# An IAM role that we attach to the EC2 Instances 
resource "aws_iam_role" "nat_assume_role" {
  name = "nat-role"
  assume_role_policy = <<HEREDOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com.cn"
      },
      "Action": "sts:AssumeRole"
    }
   ]
  }
  HEREDOC

  lifecycle { create_before_destroy = true }
}

# IAM policy we add to NAT instances that allows them to do their thing

resource "aws_iam_role_policy" "nat_instance_policy" {
  name = "nat-instance-policy"
  role = "${aws_iam_role.nat_assume_role.id}"
  policy = <<HEREDOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "NAT_Takeover",
      "Effect": "Allow",
      "Action": [
			"ec2:DescribeInstances",
			"ec2:DescribeRouteTables",
			"ec2:CreateRoute",
			"ec2:ReplaceRoute",
			"ec2:StartInstances",
			"ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}  
  HEREDOC

  lifecycle { create_before_destroy = true }
}