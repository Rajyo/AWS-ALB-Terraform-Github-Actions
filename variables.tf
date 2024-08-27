variable "vpc_cidr" {
  description = "VPC_CIDR_Range"
  type = string
}


variable "public_subnet_cidrs" {
  description = "Public_Subnets_CIDR_Range"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private_Subnets_CIDR_Range"
  type = list(string)
}

variable "public_subnet_names" {
  description = "Public Subnet Names"
  type = list(string)
  default = [ "Public-Subnet-1", "Public-Subnet-2" ]
}
variable "private_subnet_names" {
  description = "Private Subnet Names"
  type = list(string)
  default = [ "Private-Subnet-1", "Private-Subnet-2" ]
}


