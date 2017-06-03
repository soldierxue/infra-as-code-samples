/*
 *  Samples to create a PHP website
 *  AWS Resources includes:
 *      (1) One EC2 instance host PHP website in public subnet
 *      (2) One EC2 instance host mysql db in private subnet 
 * 
 *  Depends: This sample will use the exist infrastruce so it depends on sample "vpcfull-s3backend"
 *      You need to run it after "vpcfull-s3backend" is ready
 *
 *  Usage:
 *      git clone https://github.com/soldierxue/infra-as-code-samples
 *      cd ./infra-as-code-samples/bjs/vpcfull-s3backend
 *      terraform init
 *      terraform get --update
 *      terraform plan
 *      terraform apply 
 *
 *      cd ./infra-as-code-samples/bjs/phpdemo-s3backend
 *      terraform init
 *      terraform get --update
 *      terraform plan
 *      terraform apply 
 */
provider "aws" {
  region = "cn-north-1"
}

data "terraform_remote_state" "bjs" {
  backend = "s3"
  config {
    bucket = "terraform"
    key    = "network/terraform.tfstate"
    region = "cn-north-1"
  }
}

module "demophp" {
    source = "github.com/soldierxue/terraformlib/bjs-infra/demo-php"
    name ="${data.terraform_remote_state.bjs.stack_name}"
    environment = "${data.terraform_remote_state.bjs.environment}"
    vpc_id          = "${data.terraform_remote_state.bjs.vpc_id}"
    public_subnet_id = "${data.terraform_remote_state.bjs.subnet_public_ids[0]}"
    fronend_web_sgid = "${data.terraform_remote_state.bjs.sg_frontend_id}"

    private_subnet_id = "${data.terraform_remote_state.bjs.subnet_private_ids[0]}"
    database_sgid = "${data.terraform_remote_state.bjs.sg_database_id}"

    ec2keyname = "bjsMyKey"
}