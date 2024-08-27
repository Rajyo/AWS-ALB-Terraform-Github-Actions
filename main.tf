module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_names = var.public_subnet_names
  private_subnet_names = var.private_subnet_names
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.my_vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  my_sg = module.sg.my_sg_id
  my_public_subnets = module.vpc.my_public_subnets
}

module "alb" {
  source = "./modules/alb"
  my_sg_id = module.sg.my_sg_id
  my_public_subnets = module.vpc.my_public_subnets
  vpc_id = module.vpc.my_vpc_id
  ec2_instances = module.ec2.ec2_instances
}