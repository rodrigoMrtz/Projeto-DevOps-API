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