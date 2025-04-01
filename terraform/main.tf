terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.0"
    }
  }
}

provider "aws" {
  region = "me-central-1"
}

# Module for creating a VPC with 2 Public & 2 Private subnets

module "sts-vpc" {
  source = "./modules/vpc"
}

# Randomly selecting 1 public subnet where the NAT Gateway will be placed

resource "random_shuffle" "random_public_subnet" {
  input        = module.sts-vpc.public_subnet[*].id
  result_count = 1
}

# Module for creating a NAT Gateway in one of the public subnet

module "nat_gateway" {
  source                 = "./modules/nat-gateway"
  subnet_id              = random_shuffle.random_public_subnet.result[0]
  private_route_table_id = module.sts-vpc.private_route_table_id
}

# Module for creating an ECS Cluster

module "ecs_cluster" {
  source = "./modules/ecs"
}

# Module for creating an ECS Task definition

module "ecs_task_definition" {
  source = "./modules/ecs-task-definition"
}

# A null resource which introduces a sleep for 10 seconds after the NAT Gateway is created
# Since there might be a sligh delay in the connections to the internet to be done through NAT Gateway

resource "null_resource" "wait_for_nat_gateway" {
  depends_on = [module.nat_gateway]

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# Module for creating a task in the private subnets and assigning a security group to the task

module "ecs_run_task" {
  source            = "./modules/ecs-task"
  ecs_cluster_id    = module.ecs_cluster.cluster_id
  ecs_task_arn      = module.ecs_task_definition.ecs_task_definition_arn
  security_group_id = module.sts-vpc.ecs_task_sg
  private_subnets   = module.sts-vpc.private_subnets[*].id
  sts_target_group  = module.sts_alb.sts_tg_id
  depends_on        = [null_resource.wait_for_nat_gateway]
}

# A null resource which introduces a sleep for 30 seconds since once the task is created
# there is a slight delay in the network interface to be available.
# This is done since the private ip of the network interface is required to be registered
# with the target group.

resource "null_resource" "wait_for_ecs_run_task" {
  depends_on = [module.ecs_run_task]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

# A data resource to get the ID of an ENI which has a particular security group ID
# This will be needed to get the private IP which needs to added to the target group

data "aws_network_interface" "eni_with_sg" {
  filter {
    name   = "group-id"
    values = [module.sts-vpc.security_group_id]
  }
  depends_on = [null_resource.wait_for_ecs_run_task]
}

# Modules for creating an ALB, ALB listener which forwards to the target group

module "sts_alb" {
  source            = "./modules/alb"
  public_subnet_ids = module.sts-vpc.public_subnet[*].id
  vpc_id            = module.sts-vpc.vpc_id
  target_ip         = data.aws_network_interface.eni_with_sg.private_ip
}