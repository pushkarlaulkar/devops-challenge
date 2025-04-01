
# Creating a target group which will have the ECS task IP as the targets
resource "aws_lb_target_group" "sts-tg" {
  name        = "sts-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Ensures ECS registers task private IPs instead of instance IDs

  health_check {
    path                = "/"
    interval            = 90
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

# Attaching the target group to the target IP
resource "aws_lb_target_group_attachment" "sts-tg-register-ip" {
  target_group_arn = aws_lb_target_group.sts-tg.arn
  target_id        = var.target_ip
  port             = 80
}

# Allowing all traffic to ALB on port 80 from all IP 
resource "aws_security_group" "sts-alb-sg" {
  name        = "Allow Port 80 from all"
  description = "Allow Port 80 from all"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Port 80 from all"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress"
  }

  tags = {
    Name = "ALB SG"
  }
}

# Creating ALB in public subnets and attaching the above SG to it
resource "aws_lb" "sts-alb" {
  name               = "sts-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sts-alb-sg.id]
  subnets            = var.public_subnet_ids
}

# Creating a listener on port 80 and forwarding to the target group
resource "aws_lb_listener" "foo" {
  load_balancer_arn = aws_lb.sts-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sts-tg.arn
  }
}
