# The ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = "${var.name}"
}
