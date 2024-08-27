variable "vpc_id" {}


output "my_sg_id" {
  value = aws_security_group.my-sg.id
}


resource "aws_security_group" "my-sg" {
  name = "my-sg"
  description = "Allow HTTP, SSH inbound traffic"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP Nextjs App access"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow Express Server App access"
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }


  ingress {
    description = "Allow HTTPS access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  ingress {
    description = "Allow SSH access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "Allow outgoing request"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "my-security-group"
  }
  
}