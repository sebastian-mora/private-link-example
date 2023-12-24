
data "aws_caller_identity" "current" {}

// create the service endpoint
resource "aws_vpc_endpoint_service" "example" {
  acceptance_required = false
  network_load_balancer_arns = [
    aws_alb.network.arn
  ]
  tags = {
    Name = "example"
  }
}

resource "aws_vpc_endpoint_service_allowed_principal" "allow_local_account" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.example.id
  principal_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}
