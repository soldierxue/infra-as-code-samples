module "mysqldb" {
   source = "github.com/terraform-community-modules/tf_aws_rds"
   rds_instance_identifier ="petrds"
   #rds_is_multi_az = true
   rds_storage_type = "gp2"
   rds_allocated_storage = 20
   rds_engine_type = "mysql"
   rds_engine_version = "5.6.35"
   rds_instance_class = "db.t2.large"

   database_name = "petclinicdb"
   database_user = "petdbuser"
   database_password = "petdbpwd"
   db_parameter_group = "mypet5.6"

   subnets = "${module.apstack.subnet_private_ids}"
   database_port = "3306"
   private_cidr = ["${module.apstack.base_cidr_block}"]
   rds_vpc_id = "${module.apstack.vpc_id}"

   tags {
        terraform = "true"
        env       = "${terraform.env}"
   }
}