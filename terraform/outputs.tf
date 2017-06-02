output vpc_id {
  value = "${module.m_global_vpc.vpc_id}"
}

output subnet_private_ids {
  value = "${module.m_global_vpc.subnet_private_ids}"
}

output subnet_public_ids {
  value = "${module.m_global_vpc.subnet_public_ids}"
}

output private_route_ids {
  value = "${module.m_global_vpc.private_route_ids}"
}

output base_cidr_block {
  value = "${module.m_global_vpc.base_cidr_block}"
}

output sg_database_id {
  value = "${module.m_sg.sg_database_id}"
}

output sg_frontend_id {
  value = "${module.m_sg.sg_frontend_id}"
}

output sg_internal_id {
  value = "${module.m_sg.sg_internal_id}"
}

