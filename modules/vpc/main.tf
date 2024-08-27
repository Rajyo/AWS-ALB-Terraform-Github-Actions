variable "vpc_cidr" {}
variable "public_subnet_cidrs" {}
variable "private_subnet_cidrs" {}
variable "public_subnet_names" {}
variable "private_subnet_names" {}


output "my_vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "my_public_subnets" {
  value = aws_subnet.my_public_subnets
}


# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "my-virtual-private-cloud"
  }
}


data "aws_availability_zones" "available_zones" {
  state = "available"
}

# Public Subnets
resource "aws_subnet" "my_public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

# Private Subnets
resource "aws_subnet" "my_private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  tags = {
    Name = var.private_subnet_names[count.index]
  }
}


# Intenet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-internet-gateway"
  }
}


# Route Table
resource "aws_route_table" "my_public_subnet_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-public-subnet-route-table"
  }
}


# Route Table Association
resource "aws_route_table_association" "my-rt-association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.my_public_subnets[count.index].id
  route_table_id = aws_route_table.my_public_subnet_rt.id
}
