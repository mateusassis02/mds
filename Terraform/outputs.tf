# Exibe os endereços IP públicos das instâncias criadas como resultado de saída
output "ip_address" {
  value = aws_instance.web[*].public_ip
}


