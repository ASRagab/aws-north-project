resource "aws_lb" "private_alb" {
  name                             = "core-private-alb"
  load_balancer_type               = "application"
  internal                         = true
  drop_invalid_header_fields       = true
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true
  subnets                          = [var.subnet_ids[0], var.subnet_ids[1]]
  security_groups                  = [aws_security_group.private_alb.id]
  ip_address_type                  = "dualstack"
  access_logs {
    bucket  = aws_s3_bucket.access_logs.id
    prefix  = "private-alb"
    enabled = true
  }
}

resource "aws_lb_listener" "private_alb_http" {
  load_balancer_arn = aws_lb.private_alb.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "private_alb_https" {
  load_balancer_arn = aws_lb.private_alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.this.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = ":)"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "private_alb_http" {
  name        = "core-private-alb-http"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "private_alb_http" {
  target_group_arn = aws_lb_target_group.private_alb_http.arn
  target_id        = aws_lb.private_alb.arn
  port             = 80
}

resource "aws_lb_target_group" "private_alb_https" {
  name        = "core-private-alb-https"
  target_type = "alb"
  port        = 443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "private_alb_https" {
  target_group_arn = aws_lb_target_group.private_alb_https.arn
  target_id        = aws_lb.private_alb.arn
  port             = 443
}

// #####################################################################################
// Private NLB

resource "aws_lb" "private_nlb" {
  name                             = "core-private-nlb"
  load_balancer_type               = "network"
  internal                         = true
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true
  subnets                          = [var.subnet_ids[0], var.subnet_ids[1]]
  security_groups                  = [aws_security_group.private_nlb.id]
  ip_address_type                  = "dualstack"
  access_logs {
    bucket  = aws_s3_bucket.access_logs.id
    prefix  = "private-nlb"
    enabled = true
  }
}

data "aws_network_interface" "nlb" {
  # This fetches the NLB IP addresses for use in health check SG rules
  count = var.subnet_count
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.private_nlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [tolist(aws_lb.private_nlb.subnets)[count.index]]
  }
}

