output "public_subnet" {
  value = aws_subnet.sts-public-subnet[*]
}

output "private_route_table_id" {
  value = aws_route_table.sts-private-rt.id
}