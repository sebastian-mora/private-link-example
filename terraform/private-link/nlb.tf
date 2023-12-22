
// create network load balancer to front an alb 
resource "aws_alb" "network" {
  name               = "example-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = var.security_groups
  tags = {
    Name = "example-nlb"
  }
}

// create target group
resource "aws_lb_target_group" "alb" {
  name        = "alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

// register alb to target group
resource "aws_lb_target_group_attachment" "example_target_group_attachment" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        = var.alb_arn
  port             = 80
}

// add listener to nlb 
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_alb.network.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

