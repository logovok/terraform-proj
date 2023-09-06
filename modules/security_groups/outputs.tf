output "security_group_load_balancer_id" {
  value = aws_security_group.load_balancer.id
}

output "security_group_tomcats_id" {
  value = aws_security_group.tomcats.id
}

output "security_group_backend_services_id" {
  value = aws_security_group.backend_services.id
}