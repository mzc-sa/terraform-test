data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "MEGA10"
    workspaces = {
      name = "terraform-test"
    }
  }
}

# module "security-group" {
#   source  = "app.terraform.io/MEGA10/security-group/aws"
#   version = "1.0.2"

#   name   = "${var.name}-sg"
#   vpc_id = "vpc-0e2f0a7cf315d71cc"
#   #vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
#   ingress_cidr_blocks = ["10.10.0.0/16"]
#   ingress_rules       = ["https-80-tcp"]
# }

module "s3" {
  source  = "app.terraform.io/MEGA10/s3/aws"
  version = "1.0.0"

  bucket = var.bucket
  tags   = var.tags
}

module "vpc" {
  source  = "app.terraform.io/MEGA10/vpc/aws"
  version = "1.0.7"

  name = var.name
  cidr = var.cidr
  azs  = var.azs

  enable_nat_gateway     = var.enable_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  single_nat_gateway     = var.single_nat_gateway

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
