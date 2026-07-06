variable "aws_region" {
  description = "Região da AWS onde a infraestrutura será criada"
  type        = string
  default     = "us-east-1"
}

variable "projeto_name" {
  description = "Nome padrão para identificar os recursos do projeto"
  type        = string
  default     = "projeto-api-devops"
}

variable "ssh_public_key" {
  type        = string
  description = "Chave pública SSH ED25519 para acesso à instância EC2"
}