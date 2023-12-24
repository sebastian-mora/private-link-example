resource "aws_lb" "hello_world" {
  name               = "hello-world-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_inbound_80_self.id]
  subnets            = var.subnet_ids

  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "example-alb"
  }
}



// create target group
resource "aws_lb_target_group" "hello_world" {
  name     = "hello-world-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

// register instance to target group
resource "aws_lb_target_group_attachment" "hello_world" {
  target_group_arn = aws_lb_target_group.hello_world.arn
  target_id        = aws_instance.example_instance.id
  port             = 80
}

// create alb listener 
resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = aws_lb.hello_world.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.hello_world.arn
    type             = "forward"
  }
}

