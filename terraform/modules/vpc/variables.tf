variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    { cidr_block = "10.0.1.0/24", availability_zone = "me-central-1a" },
    { cidr_block = "10.0.2.0/24", availability_zone = "me-central-1b" }
  ]
}

variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    { cidr_block = "10.0.3.0/24", availability_zone = "me-central-1a" },
    { cidr_block = "10.0.4.0/24", availability_zone = "me-central-1b" }
  ]
}