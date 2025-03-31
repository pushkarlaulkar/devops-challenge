variable "ecs_cluster_id" {
  description = "Cluster ID"
  type        = string
}

variable "ecs_task_arn" {
  description = "ECS Task ARN"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for ECS task"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}