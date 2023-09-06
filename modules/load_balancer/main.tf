resource "aws_lb" "vprofile_lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_load_balancer_ids
  subnets            = var.subnet_ids

  tags = {
    Project = "vprofile"
  }
}

resource "aws_lb_target_group" "instance_tg" {
   name               = var.name
   target_type        = "instance"
   port               = 8080
   protocol           = "HTTP"
   vpc_id             = var.vpc_id
   health_check {
      healthy_threshold   = var.health_check["healthy_threshold"]
      interval            = var.health_check["interval"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]
      timeout             = var.health_check["timeout"]
      path                = var.health_check["path"]
      port                = var.health_check["port"]
  }
}

resource "aws_lb_target_group_attachment" "my-target-group-attach" {
  target_group_arn = aws_lb_target_group.instance_tg.arn
  target_id        = var.app_instance_id
  port             = "8080"
}


resource "aws_lb_listener" "vprofile_http" {
  load_balancer_arn = aws_lb.vprofile_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_tg.arn
  }
}

data "aws_acm_certificate" "issued" {
  count = var.domain != "" ? 1 : 0
  domain   = var.domain
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "vprofile_https" {
  count = var.domain != "" ? 1 : 0
  load_balancer_arn = aws_lb.vprofile_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_tg.arn
  }
}

output "load_balancer_domain" {
  value = aws_lb.vprofile_lb.dns_name
}