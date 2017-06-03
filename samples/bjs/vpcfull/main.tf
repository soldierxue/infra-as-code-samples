/*
 *  Samples to create a full vpc stack with public/private subnets & HA-NAT instances
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, roles for NAT instances
 *      (3) Scripts to monitor NAT instance healthy and update routes
 */
module "bjs-vpc" {
  source          = "github.com/soldierxue/infra-as-code-samples/terraform/bjs-infra"
  region          = "cn-north-1"
  base_cidr_block = "10.0.0.0/16"
  stack_name = "bjsdemo"
  environment = "test"
  ec2keyname = "bjsMyKey"
  keyfile = "~/bjsMyKey.pem"
  subnet_private_cidrs = ["10.0.48.0/20","10.0.112.0/20"]
  subnet_public_cidrs = ["10.0.0.0/20","10.0.16.0/20"]
}