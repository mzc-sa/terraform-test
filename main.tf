//--------------------------------------------------------------------
// Modules
//--------------------------------------------------------------------

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}


##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  tags = {
    Environment = "test"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Tier = "public"
  }
}

data "aws_ami" "amazon_linux_2" {
 most_recent = true
 owners = [ "amazon" ]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}


##################################################################
# Bastion Host Instance (EC2)
##################################################################

resource "aws_eip" "this" {
  vpc      = true
  instance = module.ec2_cluster.id[0]
  tags = {
    Name = "${var.name}-eip"
  }
}

module "ec2_cluster" {
  source  = "app.terraform.io/MEGAZONE-test/ec2/aws"
  version = "1.0.0"

  instance_count = 1

  # Instance
  name                        = var.name
  key_name                    = var.key_name
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id_enabled ? var.subnet_id : tolist(data.aws_subnet_ids.public.ids)[0]
  private_ip                  = var.private_ip
  associate_public_ip_address = true

  # UserData
  user_data_base64 = base64encode(local.user_data)

  # Volume
  root_block_device = var.root_block_device

  # Tags
  tags        = var.tags
  volume_tags = var.volume_tags
}
