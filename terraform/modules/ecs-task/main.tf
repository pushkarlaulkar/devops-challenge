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
}
