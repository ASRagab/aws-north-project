resource "aws_security_group" "msk_sg" {
  name        = "msk-sg"
  description = "Security group for MSK"
  vpc_id      = aws_vpc.core.id

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core.cidr_block]
  }

  ingress {
    from_port   = 9092
    to_port     = 9098
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core.cidr_block]
  }

  ingress {
    from_port   = 9198
    to_port     = 9198
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fargate_sg" {
  name        = "fargate-sg"
  description = "Security group for Fargate tasks"
  vpc_id      = aws_vpc.core.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core.cidr_block]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.core.cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fargate-security-group"
  }
}


