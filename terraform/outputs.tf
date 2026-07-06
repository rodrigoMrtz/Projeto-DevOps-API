output "ec2_public_ip" {
  description = "O endereço IP público da instância EC2 criada"
  value       = aws_instance.web_server.public_ip
}