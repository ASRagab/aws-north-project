resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.core.id
  tags = {
    Name        = "core.network.public"
    Description = "Core VPC public IGW"
  }
}

resource "aws_egress_only_internet_gateway" "private" {
  vpc_id = aws_vpc.core.id
  tags = {
    Name        = "core.network.private.eigw"
    Description = "Core VPC private EIGW"
  }
}

resource "aws_nat_gateway" "private" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.public_ngw.id
  tags = {
    Name        = "core.network.private.ngw"
    Description = "Core VPC NGW"
  }
}

resource "aws_eip" "public_ngw" {
  domain = "vpc"
  tags = {
    Name = "core.network.private.ngw"
  }
}

