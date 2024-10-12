resource "aws_route53_zone" "public" {
  name    = var.domain_name
  comment = "core domain public zone"
}

resource "aws_route53_zone" "private" {
  name    = "internal.${var.domain_name}"
  comment = "core domain private zone"
  vpc {
    vpc_id = aws_vpc.core.id
  }
}



