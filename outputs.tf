output "alb_dns_name" {
  description = "Public DNS of the ALB. Open this in your browser."
  value       = aws_lb.web.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "asg_name" {
  value = aws_autoscaling_group.web.name
}