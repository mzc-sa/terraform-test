##################################################################
# Data sources to get VPC and subnets
##################################################################
data "aws_vpc" "default" {
  tags = {
    Environment = "*"
  }
}
#Environment
#data "aws_subnet_ids" "all" {
#  vpc_id = data.aws_vpc.default.id
#
#  tags = {
#    Tier      = "public"
#    Terraform = "true"
#  }
#}
#
#data "aws_security_group" "default" {
#  vpc_id = data.aws_vpc.default.id
#  name   = "default"
#}


############
# ELB
############
module "elb" {
  source  = "app.terraform.io/MEGAZONE-prod/elb/aws"
  version = "1.0.3"

  name = "${var.name}-alb"
  
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  vpc_id             = var.vpc_id
  subnets            = var.subnets 
  security_groups    = var.security_groups

  target_groups = [
    {
      name             = "${var.name}-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      target_group_index = 0
    }
  ]

  tags = var.tags
  lb_tags = var.lb_tags

}
