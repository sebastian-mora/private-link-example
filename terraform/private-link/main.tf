
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