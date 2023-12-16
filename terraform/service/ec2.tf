
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example_instance" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t2.micro" # Change the instance type if needed
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  subnet_id              = var.subnet_ids[0]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              service nginx start
              EOF

  tags = {
    Name = "example_instance"
  }
}


resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Allow traffic on 8080"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    self      = true
  }
}
