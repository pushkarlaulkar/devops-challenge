output "public_subnet" {
  value = aws_subnet.sts-public-subnet[*]
}

output "private_subnets" {
  value = aws_subnet.sts-private-subnet[*]
}

output "private_route_table_id" {
  value = aws_route_table.sts-private-rt.id
}

output "ecs_task_sg" {
  value = aws_security_group.sts-ecs-task-sg.id
}

output "security_group_id" {
  value = aws_security_group.sts-ecs-task-sg.id
}

output "vpc_id" {
  value = aws_vpc.sts-vpc.id
}