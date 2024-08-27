variable "my_sg" {}
variable "my_public_subnets" {}


data "aws_availability_zones" "available-zone" {
  state = "available"
}

output "ec2_instances" {
  value = aws_instance.my-ec2-instances
}

resource "aws_instance" "my-ec2-instances" {
  count = length(var.my_public_subnets)
  ami = "ami-0d53d72369335a9d6"
  instance_type = "t2.micro"
  security_groups = [ var.my_sg ]
  associate_public_ip_address = true
  subnet_id = var.my_public_subnets[count.index].id
  availability_zone = data.aws_availability_zones.available-zone.names[count.index]
  user_data = <<EOF
#!/bin/bash
sudo apt-get update

sudo apt-get install docker.io -y

sudo systemctl enable docker --now
sudo usermod -aG docker ubuntu
newgrp docker
sudo service docker restart

docker run -d -p 80:8000 prajyot7/express-server-${count.index + 1}:v1
EOF
  tags = {
    Name = "My-ec2-Instance-${count.index}"
  }
}

