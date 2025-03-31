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

module "sts-vpc" {
  source = "./modules/vpc"
}

#Randomly selecting 1 public subnet where the NAT Gateway will be placed
resource "random_shuffle" "random_public_subnet" {
  input        = module.sts-vpc.public_subnet[*].id
  result_count = 1
}

module "nat_gateway" {
  source                 = "./modules/nat-gateway"
  subnet_id              = random_shuffle.random_public_subnet.result[0]
  private_route_table_id = module.sts-vpc.private_route_table_id
}

module "ecs_cluster" {
  source = "./modules/ecs"
}

module "ecs_task_definition" {
  source = "./modules/ecs-task-definition"
}