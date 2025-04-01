# This variable contains the ID of the public subnet in which the NAT GW will be created

variable "subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

# This variable contains the ID of the private route table in which a route to internet through the NAT GW will be added

variable "private_route_table_id" {
  description = "The ID of the private route table to update"
  type        = string
}