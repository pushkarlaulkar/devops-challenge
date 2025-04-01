# Creating ans ECS Task execution role

resource "aws_iam_role" "sts-ecs-execution-role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Creating the policy to the role

resource "aws_iam_role_policy_attachment" "sts-ecs-execution-role-policy" {
  role       = aws_iam_role.sts-ecs-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Creating a task definition which will be used to create the task.
# Fargate has been used here.
# CPU is 512 M, Memory is 1G and container and host port is 80
# Using the docker hub image

resource "aws_ecs_task_definition" "sts-ecs-task" {
  family                   = "simple-time-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"

  execution_role_arn = aws_iam_role.sts-ecs-execution-role.arn

  container_definitions = jsonencode([
    {
      name      = "simple-time-service-container"
      image     = "plaulkar/simple-time-service:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
