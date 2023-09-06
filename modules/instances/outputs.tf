output "db01_private_ip" {
  value = aws_instance.vprofile_db01.private_ip
}

output "mc01_private_ip" {
  value = aws_instance.vprofile_mc01.private_ip
}

output "rmq01_private_ip" {
  value = aws_instance.vprofile_rmq01.private_ip
}

output "app_instance_id" {
  value = aws_instance.vprofile_app01.id
}