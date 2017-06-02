# Application load balancer that distributes load between the instances
resource "aws_alb" "dmz-alb" {
  name = "${format("alb-%s-%s-%s", var.name, var.stack_name,var.environment)}"
  internal = false

  security_groups = [
    "${var.security_group_internal_id}",
    "${var.security_group_inbound_id}",
  ]

  subnets = "${var.alb_subnet_ids}"
  tags {
    Name        = "${var.name}-balancer"
    Service     = "${var.name}"
    Environment = "${var.environment}"
  }
}

# Default ALB target group that defines the default port/protocol the instances will listen on
resource "aws_alb_target_group" "instance_tg" {
  name = "${format("tg-%s-%s-%s", var.name, var.stack_name,var.environment)}"
  protocol = "HTTP"
  port = "${var.port_forward}"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/"
  }
}

# ALB listener that checks for connection requests from clients using the port/protocol specified
# These requests are then forwarded to one or more target groups, based on the rules defined
resource "aws_alb_listener" "instance_listener" {
  load_balancer_arn = "${aws_alb.dmz-alb.arn}"
  port = "${var.port_listen}"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.instance_tg.arn}"
    type = "forward"
  }

  depends_on = ["aws_alb_target_group.instance_tg"]
}
