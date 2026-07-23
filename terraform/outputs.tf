output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "public_dns" {
  description = "Public DNS hostname of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "website_url" {
  description = "URL to access the web application"
  value       = "http://${aws_instance.web_server.public_ip}"
}
