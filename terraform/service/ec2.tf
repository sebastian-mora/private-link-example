
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
  vpc_security_group_ids = [aws_security_group.allow_inbound_vpc.id]
  subnet_id              = var.subnet_ids[0]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "example_instance"
  }
}


resource "aws_security_group" "allow_inbound_vpc" {
  name        = "allow_inbound_vpc"
  description = "Allow traffic on 8080"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    self      = true
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
