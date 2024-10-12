resource "aws_vpc" "core" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    Name = "Core"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region_name}.secretsmanager"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  vpc_id              = aws_vpc.core.id
  vpc_endpoint_type   = "Interface"
  tags                = { Name = "core.network.vpce.secretsmanager" }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region_name}.ecr.dkr"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  vpc_id              = aws_vpc.core.id
  vpc_endpoint_type   = "Interface"
  tags                = { Name = "core.network.vpce.ecr-dkr" }
}

resource "aws_vpc_endpoint" "s3" {
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region_name}.s3"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  vpc_id              = aws_vpc.core.id
  vpc_endpoint_type   = "Gateway"
  tags                = { Name = "core.network.vpce.s3" }
}

resource "aws_vpc_endpoint" "logs" {
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region_name}.logs"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]
  security_group_ids  = [aws_security_group.vpce.id]
  vpc_id              = aws_vpc.core.id
  vpc_endpoint_type   = "Interface"
  tags                = { Name = "core.network.vpce.logs" }
}

resource "aws_security_group" "vpce" {
  name        = "core.network.vpce"
  description = "VPC endpoint access"
  vpc_id      = aws_vpc.core.id
  ingress {
    description      = "Ingress local subnets"
    cidr_blocks      = [aws_vpc.core.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.core.ipv6_cidr_block]
    protocol         = "tcp"
    from_port        = "443"
    to_port          = "443"
  }
  egress {
    description      = "Egress all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    from_port        = "0"
    to_port          = "0"
  }
  lifecycle {
    create_before_destroy = true
  }
}