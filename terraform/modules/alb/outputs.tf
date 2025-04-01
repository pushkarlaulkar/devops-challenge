output "sts_tg_id" {
  value = aws_lb_target_group.sts-tg.id
}

output "alb_dns_name" {
  value = aws_lb.sts-alb.dns_name
}