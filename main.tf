//--------------------------------------------------------------------
// Modules
//--------------------------------------------------------------------
##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  tags = {
    Environment = "qa"
  }
}


##################################################################
# Security Group
##################################################################
module "security-group" {
  source  = "app.terraform.io/MEGAZONE-prod/security-group/aws"
  version = "1.0.4"

  name            = var.name
  description     = var.description
  vpc_id          = data.aws_vpc.default.id
 
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = 
  
  tags = var.tags 
}
