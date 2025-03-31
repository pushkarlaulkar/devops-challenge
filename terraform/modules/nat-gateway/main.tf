resource "aws_eip" "sts-eip" {
  domain = "vpc"

  tags = {
    Name = "sts-eip"
  }
}

resource "aws_nat_gateway" "sts-nat-gw" {
  allocation_id = aws_eip.sts-eip.id
  subnet_id     = var.subnet_id

  tags = {
    Name = "sts-nat-gateway"
  }

}

resource "aws_route" "nat" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.sts-nat-gw.id
}