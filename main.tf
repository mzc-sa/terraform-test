//--------------------------------------------------------------------
// Modules

module "vpc" {
  source  = "app.terraform.io/MEGA10/vpc/aws"
  version = "1.0.5"

  name = "Today-vpc"
  cidr = "10.10.0.0/16"
  azs = ["ap-northeast-2a", "ap-northeast-2c"]
  enable_nat_gateway = "true"
  one_nat_gateway_per_az = "true"
  single_nat_gateway = "true"

  private_subnets = ["10.10.100.0/24", "10.10.101.0/24"]
  public_subnets = ["10.10.1.0/24", "10.10.2.0/24"]

  tags = { Terraform = "true", Environment = "dev" }
}
