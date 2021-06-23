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

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Tier        = "private"
    Environment = "*"
  }
}


################
# Local Variable
################
locals {
  vpc_id          = ( var.vpc_id == true  ? var.vpc_id : data.aws_vpc.default.id  )
  public_subnets  = ( var.subnets != "" && var.internal == false ? var.subnets : data.aws_subnet_ids.public.ids )
#  private_subnets = ( var.internal == true ? var.subnets : data.aws_subnet_ids.private.ids )
#   subnets = ( var.internal == false ? data.aws_subnet_ids.public.ids : data.aws_subnet_ids.private.ids )
 
  depends_on = [
    data.aws_vpc.default.id,
    data.aws_subnet_ids.public.ids,
    data.aws_subnet_ids.private.ids
  ]
}


############
# ELB Module
############
module "extarnal_elb" {
  source  = "app.terraform.io/MEGAZONE-prod/elb/aws"
  version = "1.0.3"
   
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  vpc_id             = local.vpc_id
  subnets            = var.public_subnets
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
  
resource "aws_security_group" "http" {
  name   = "${var.name}-web-sg"
  vpc_id = data.aws_vpc.default.id
  
  tags = {
    Name = "${var.name}-web-sg"
  }
}

module "internal_elb" {
  source  = "app.terraform.io/MEGAZONE-prod/elb/aws"
  version = "1.0.3"
 
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  vpc_id             = local.vpc_id
  subnets            = private_subnets
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
  
resource "aws_security_group" "http" {
  name   = "${var.name}-web-sg"
  vpc_id = data.aws_vpc.default.id
  
  tags = {
    Name = "${var.name}-web-sg"
  }
}
