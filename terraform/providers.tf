terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configurando o Provedor AWS e apontando para a variável de região
provider "aws" {
  region = var.aws_region
}

# Configura o acesso ao seu GitHub usando um Token de Acesso Pessoal (PAT)
provider "github" {
  token = var.github_token
}