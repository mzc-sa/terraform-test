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
  source  = "app.terraform.io/MEGAZONE-qa/security-group/aws"
  version = "1.0.4"

  name            = var.name
  description     = var.description
  vpc_id          = data.aws_vpc.default.id
 
  # Ingress
  ingress_rules            = var.ingress_rules
  ingress_cidr_blocks      = var.ingress_cidr_blocks
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  
  # Egress
  egress_rules             = var.egress_rules
  egress_cidr_blocks       = var.egress_cidr_blocks
#   egress_with_cidr_blocks  = var.egress_with_cidr_blocks
  
  # Tags
  tags = var.tags 
}
