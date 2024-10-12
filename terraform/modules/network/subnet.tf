locals {
  az_count = 3
}

resource "aws_subnet" "public" {
  count                           = var.subnet_count
  cidr_block                      = cidrsubnet(aws_vpc.core.cidr_block, 4, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.core.ipv6_cidr_block, 8, count.index)
  availability_zone               = data.aws_availability_zones.available.names[count.index % local.az_count]
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  vpc_id                          = aws_vpc.core.id
  tags = {
    Name        = "core.network.public${count.index + 1}"
    Description = "Public subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                           = var.subnet_count
  cidr_block                      = cidrsubnet(aws_vpc.core.cidr_block, 4, count.index + 4)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.core.ipv6_cidr_block, 8, count.index + 4)
  availability_zone               = data.aws_availability_zones.available.names[(count.index + 4) % local.az_count]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true
  vpc_id                          = aws_vpc.core.id
  tags = {
    Name        = "core.network.private${count.index + 1}"
    Description = "Private subnet ${count.index + 1}"
  }
}

data "aws_availability_zones" "available" {}