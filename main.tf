//--------------------------------------------------------------------
// Modules

module "vpc" {
  source  = "app.terraform.io/MEGA10/vpc/aws"
  version = "1.0.6"

  name = var.name
  cidr = var.cidr
  azs  = var.azs

  enable_nat_gateway     = var.enable_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  single_nat_gateway     = var.single_nat_gateway

  enable_dns_hostnames = var.enable_dns_hostnames

  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  tags = var.tags
  igw_tags = {
    Name = "${var.name}-igw"
  }

  nat_eip_tags = {
    Name = "${var.name}-nat-eip"
  }

  nat_gateway_tags = {
    Name = "${var.name}-nat-gw"
  }
  private_subnet_tags = {
    Tier = "private"
  }

  private_route_table_tags = {
    Name = "${var.name}-private-rt"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  public_route_table_tags = {
    Name = "${var.name}-public-rt"
  }
}
