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


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.example_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
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
