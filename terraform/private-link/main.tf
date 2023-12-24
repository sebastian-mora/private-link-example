
data "aws_caller_identity" "current" {}

// create the service endpoint
resource "aws_vpc_endpoint_service" "hello_world_service" {
  acceptance_required = false
  network_load_balancer_arns = [
    aws_alb.network.arn
  ]
  tags = {
    Name = "hello-world-service"
  }
}

// loop over allowed principles and created allowed principals
resource "aws_vpc_endpoint_service_allowed_principal" "allow_principals" {
  count                   = length(var.allowed_principals)
  vpc_endpoint_service_id = aws_vpc_endpoint_service.hello_world_service.id
  principal_arn           = var.allowed_principals[count.index]
}
