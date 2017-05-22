# Resources for NAT Nodes

resource "aws_instance" "nat" {
    count = "${length(data.aws_availability_zones.all.names)}"
    ami = "ami-0534fc68" # this is a special ami preconfigured to do NAT
    iam_instance_profile = "${var.instance_profile_name}"
    availability_zone = "${data.aws_availability_zones.all.names[count.index]}"
    instance_type = "m3.large"
    key_name = "${var.ec2_keyname}"
    vpc_security_group_ids = ["${var.sg_nat_id}"]
    subnet_id = "${element(var.public_subnets,count.index)}"
    associate_public_ip_address = true
    source_dest_check = false
    monitoring = true
    disable_api_termination = true

    tags {
        Name = "VPC NAT #${count.index + 1}"
    }
}

resource "aws_eip" "eip" {
    count = "${length(data.aws_availability_zones.all.names)}"
    
    instance = "${element(aws_instance.nat.*.id,count.index)}"
    vpc = true
}

resource "aws_route_table" "rt-private-nat" {
    count = "${length(data.aws_availability_zones.all.names)}"
    
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${element(aws_instance.nat.*.id,count.index)}"
    }

    tags {
        Name = "NAT Route #${count.index + 1}"
    }
}

data "aws_route_table" "selected" {
  count = "${length(data.aws_availability_zones.all.names)}"
  
  subnet_id = "${element(var.private_subnets, count.index)}"
}

resource "aws_route" "nat" {
  count = "${length(data.aws_availability_zones.all.names)}"

  route_table_id = "${element(data.aws_route_table.selected.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id = "${element(aws_instance.nat.*.id, count.index)}"
}

# Actions for nat moinitor script

resource "null_resource" "generate-nat-monitor-sh" {
  provisioner "local-exec" {
    command = "mkdir -p tmp && cp ${path.module}/scripts/nat-monitor.sh tmp/;"
  }
}

data "template_file" "nat-monitor-default" {
  count = "${length(data.aws_availability_zones.all.names)}"

  template = "${file("${path.module}/scripts/nat-monitor.default.template")}"

  vars {
    NAT_IDS = "${replace(join(" ", aws_instance.nat.*.id), "/\\s*${element(aws_instance.nat.*.id, count.index)}\\s*/", "")}"
    NAT_RT_IDS = "${replace(join(" ", aws_route_table.rt-private-nat.*.id), "/\\s*${element(aws_route_table.rt-private-nat.*.id, count.index)}\\s*/", "")}"
    My_RT_ID = "${element(aws_route_table.rt-private-nat.*.id, count.index)}"
    EC2_REGION = "${var.aws_region}"

    Num_Pings="${var.nat_monitor_num_pings}"
    Ping_Timeout="${var.nat_monitor_ping_timeout}"
    Wait_Between_Pings="${var.nat_monitor_wait_between_pings}"
    Wait_for_Instance_Stop="${var.nat_monitor_wait_for_instance_stop}"
    Wait_for_Instance_Start="${var.nat_monitor_wait_for_instance_start}"
  }
}

resource "null_resource" "provision" {
  count = "${length(data.aws_availability_zones.all.names)}"
  
  provisioner "file" {
    source = "tmp/nat-monitor.sh"
    destination = "/tmp/nat-monitor.sh"
  }

  provisioner "file" {
    source = "scripts/nat-monitor.init"
    destination = "/tmp/nat-monitor.init"
  }

  provisioner "file" {
    content = "${element(data.template_file.nat-monitor-default.*.rendered, count.index)}"
    destination = "/tmp/nat-monitor.default"
  }

  provisioner "file" {
    source = "scripts/nat-monitor.log-rotate"
    destination = "/tmp/nat-monitor.log-rotate"
  }
  
  provisioner "remote-exec" {
    inline = [
<<TFEOF
sudo sh - <<SUDOEOF
set -e
cp /tmp/nat-monitor.sh /usr/local/bin/
cp /tmp/nat-monitor.init /etc/init.d/nat-monitor
[ -d /etc/sysconfig ] && cp /tmp/nat-monitor.default /etc/sysconfig/nat-monitor
[ -d /etc/default ] && cp /tmp/nat-monitor.default /etc/default/nat-monitor
cp /tmp/nat-monitor.log-rotate /etc/logrotate.d/nat-monitor
chmod +x /usr/local/bin/nat-monitor.sh /etc/init.d/nat-monitor
chkconfig nat-monitor on
service nat-monitor restart
rm -rf /tmp/nat-monitor.*
SUDOEOF
TFEOF
    ]
  }  
  
  connection {
    user = "ec2-user"
    host = "${element(aws_eip.eip.*.public_ip, count.index)}"
    private_key = "${file("${path.module}/scripts/bjskey.pem")}"
  }

  depends_on = ["null_resource.generate-nat-monitor-sh", "aws_instance.nat","aws_route_table.rt-private-nat"]  
}


