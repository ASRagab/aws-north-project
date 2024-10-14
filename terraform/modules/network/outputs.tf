output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.core.id
}

output "vpc_ipv4_cidr" {
  description = "The IPv4 CIDR block of the VPC"
  value       = aws_vpc.core.cidr_block
}

output "vpc_ipv6_cidr" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.core.ipv6_cidr_block
}

output "private_subnet_ids" {
  description = "List of private subnet IDs in the VPC"
  value       = aws_subnet.private[*].id
}

output "public_zone_id" {
  description = "The ID of the public Route53 zone"
  value       = aws_route53_zone.public.id
}

output "public_zone_name" {
  description = "The name of the public Route53 zone"
  value       = aws_route53_zone.public.name
}

output "private_zone_name" {
  description = "The name of the private Route53 zone"
  value       = aws_route53_zone.private.name
}

output "private_zone_id" {
  description = "The ID of the private Route53 zone"
  value       = aws_route53_zone.private.id
}

output "msk_security_group_id" {
  description = "The ID of the MSK security group"
  value       = aws_security_group.msk_sg.id
}

output "fargate_security_group_id" {
  description = "The ID of the Fargate security group"
  value       = aws_security_group.fargate_sg.id
}
