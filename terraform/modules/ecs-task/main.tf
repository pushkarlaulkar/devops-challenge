# Creating an ECS Task of type FARGATE on the cluster and task definition created in the previous modules.
# Also configuring a load balancer to send traffic to this task

resource "aws_ecs_service" "ecs_run_task" {
  name            = "simple-time-service"
  cluster         = var.ecs_cluster_id
  task_definition = var.ecs_task_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.sts_target_group
    container_name   = "simple-time-service-container"
    container_port   = 80
  }
}
