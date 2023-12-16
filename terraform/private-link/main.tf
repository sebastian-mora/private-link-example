
data "aws_caller_identity" "current" {}

resource "aws_vpc_endpoint_service" "example" {
  acceptance_required        = false
  allowed_principals         = [data.aws_caller_identity.current.account_id]
  gateway_load_balancer_arns = [aws_lb.example.arn]
}

resource "aws_vpc_endpoint" "example" {
  service_name      = aws_vpc_endpoint_service.example.service_name
  subnet_ids        = [aws_subnet.example.id]
  vpc_endpoint_type = aws_vpc_endpoint_service.example.service_type
  vpc_id            = aws_vpc.example.id
}
