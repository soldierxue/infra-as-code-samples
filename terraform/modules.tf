# module to create a new vpc with at least two private subnets & two public subnets
# for global vpc, IGW & NGW will also be created
module "m_global_vpc" {
  source          = "./global-vpc"
  name          = "${var.stack_name}"
  environment  = "${var.environment}"
}

# module to create basic Security Groups,open 80, 22 for internet access
module "m_sg" {
  source          = "./security-groups"
  name          = "${var.stack_name}"
  environment  = "${var.environment}"
  vpc_id          = "${module.m_global_vpc.vpc_id}"
  vpc_cidr_block  = "${module.m_global_vpc.base_cidr_block}"
}