resource "aws_acm_certificate" "this" {
  domain_name               = "*.${var.private_zone_name}"
  subject_alternative_names = [var.private_zone_name]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

