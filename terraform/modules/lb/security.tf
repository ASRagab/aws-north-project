resource "aws_security_group" "private_alb" {
  name        = "core-private-alb"
  description = "Core private ALB"
  vpc_id      = var.vpc_id
  ingress {
    description      = "Ingress local subnets"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_ipv4_cidr]
    ipv6_cidr_blocks = [var.vpc_ipv6_cidr]
  }
  egress {
    description = "Egress all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "private_nlb" {
  name        = "core-private-nlb"
  description = "Core private NLB"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Ingress private ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.private_alb.id]
  }
  ingress {
    description      = "Ingress local subnets"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_ipv4_cidr]
    ipv6_cidr_blocks = [var.vpc_ipv6_cidr]
  }
  egress {
    description      = "Egress all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

