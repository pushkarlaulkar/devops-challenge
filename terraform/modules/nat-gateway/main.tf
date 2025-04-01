# Creating an EIP to be associated with the NAT GW

resource "aws_eip" "sts-eip" {
  domain = "vpc"

  tags = {
    Name = "sts-eip"
  }
}

# Creating a NAT GW

resource "aws_nat_gateway" "sts-nat-gw" {
  allocation_id = aws_eip.sts-eip.id
  subnet_id     = var.subnet_id

  tags = {
    Name = "sts-nat-gateway"
  }

}

# Adding a route in the private route table through the NAT GW

resource "aws_route" "private_route_nat" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sts-nat-gw.id
}