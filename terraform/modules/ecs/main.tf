# Creating an ECS Cluster

resource "aws_ecs_cluster" "simple-time-service-cluster" {
  name = "simple-time-service-cluster"
}