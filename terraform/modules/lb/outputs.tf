// #####################################################################################

output "private_alb_arn" { value = aws_lb.private_alb.arn }
output "private_alb_https_listener_arn" { value = aws_lb_listener.private_alb_https.arn }
output "private_alb_security_group_id" { value = aws_security_group.private_alb.id }
output "private_alb_hostname" { value = aws_route53_record.root_private_alb.fqdn }
output "private_nlb_arn" { value = aws_lb.private_nlb.arn }
output "private_nlb_security_group_id" { value = aws_security_group.private_nlb.id }
output "private_nlb_cidrs" { value = formatlist("%s/32", data.aws_network_interface.nlb[*].private_ip) }
output "private_nlb_hostname" { value = aws_route53_record.root_private_nlb.fqdn }
output "lb_access_log_bucket" { value = aws_s3_bucket.access_logs.bucket }

// #####################################################################################
