output "nat_gw_id" {
  description = "The ID of the NAT GW"
  value       = aws_nat_gateway.sts-nat-gw.id
}