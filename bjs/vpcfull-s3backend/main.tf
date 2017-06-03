/*
 *  Samples to create a full vpc stack with public/private subnets & HA-NAT instances
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, roles for NAT instances
 *      (3) Scripts to monitor NAT instance healthy and update routes
 *
 *  This sample diff with "vpcfull" is that, here we try to store the terraform state in s3, by default
 *  terraform store state file in local file system
 *
 * Usage:
 *      git clone https://github.com/soldierxue/infra-as-code-samples
 *      cd ./infra-as-code-samples/bjs/vpcfull-s3backend
 *      terraform get --update
 *      terraform init
 *      terraform plan
 *      terraform apply
 */
terraform {
  backend "s3" {
    bucket = "terraform"
    key    = "state"
    region = "cn-north-1"
  }
}

resource "aws_s3_bucket" "tstate" {
  bucket = "terraform"
  acl    = "private"

  tags {
    Name        = "Bucket to store terraform state"
    Environment = "Dev"
  }
}

module "bjs-vpc" {
  source          = "github.com/soldierxue/terraformlib/bjs-infra"
  region          = "cn-north-1"
  base_cidr_block = "10.0.0.0/16"
  stack_name = "bjsdemo"
  environment = "test"
  ec2keyname = "bjsMyKey"
  keyfile = "~/bjsMyKey.pem"
  subnet_private_cidrs = ["10.0.48.0/20","10.0.112.0/20"]
  subnet_public_cidrs = ["10.0.0.0/20","10.0.16.0/20"]
}
