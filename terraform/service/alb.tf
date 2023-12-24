resource "aws_lb" "example_alb" {
  name               = "example-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_inbound_vpc_http.id, aws_security_group.allow_inbound_vpc.id]
  subnets            = var.subnet_ids

  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "example-alb"
  }
}



// create target group
resource "aws_lb_target_group" "example_target_group" {
  name     = "priavate-service"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

// register instance to target group
resource "aws_lb_target_group_attachment" "example_target_group_attachment" {
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = aws_instance.example_instance.id
  port             = 80
}

// create alb listener 
resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.example_target_group.arn
    type             = "forward"
  }
}


resource "aws_security_group" "allow_inbound_vpc_http" {
  name        = "allow_inbound_vpc_http"
  description = "Allow traffic on 8080"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

}
