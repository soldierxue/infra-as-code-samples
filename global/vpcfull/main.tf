/*
 *  Samples to create a full vpc stack with public/private subnets & NAT Gateways for private subnets
 *  AWS Resources includes:
 *      (1) VPC, subnets,route tables
 *      (2) Security Groups, 
 *      (3) NAT Gateways
 */
provider "aws" {
  region = "us-east-1"
}
module "apstack" {
    source = "github.com/soldierxue/terraformlib"
    stack_name = "jasonstack"
}