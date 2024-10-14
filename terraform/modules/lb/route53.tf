
resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      record  = dvo.resource_record_value
      zone_id = var.public_zone_id
    }
  }
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  zone_id         = each.value.zone_id
  ttl             = 60
}


resource "aws_route53_record" "root_private_alb" {
  name    = ""
  type    = "A"
  zone_id = var.private_zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_lb.private_alb.dns_name
    zone_id                = aws_lb.private_alb.zone_id
  }
}

resource "aws_route53_record" "root_private_alb_wildcard" {
  name    = "*"
  type    = "A"
  zone_id = var.private_zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_lb.private_alb.dns_name
    zone_id                = aws_lb.private_alb.zone_id
  }
}

resource "aws_route53_record" "root_private_nlb" {
  name    = "nlb"
  type    = "A"
  zone_id = var.private_zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_lb.private_nlb.dns_name
    zone_id                = aws_lb.private_nlb.zone_id
  }
}

