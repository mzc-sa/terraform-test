###############
# Data sources 
###############
data "aws_vpc" "default" {
  tags = {
    Environment = "*"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Tier        = "public"
    Environment = "*"
  }
}


############
# ELB Module
############
resource "aws_security_group" "http" {
  name   = "${var.name}-sg"
  vpc_id = data.aws_vpc.default.id
  
  tags = {
    Name = "${var.name}-sg"
  }
}

module "elb_manual" {
  source  = "app.terraform.io/MEGAZONE-prod/elb/aws"
  version = "1.0.3"
  
  count = var.vpc_id != null || var.subnets != null ? 1 : 0
  
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups    = [aws_security_group.http.id]

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

module "elb_auto" {
  source  = "app.terraform.io/MEGAZONE-prod/elb/aws"
  version = "1.0.3"

  count = var.vpc_id != null || var.subnets != null ? 0 : 1
  
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  vpc_id             = data.aws_vpc.default.id
  subnets            = data.aws_subnet_ids.public.ids
  security_groups    = [aws_security_group.http.id]

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
