# 1. Configuração do Terraform e dos Plugins necessários
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. Configurando o Provedor AWS e apontando para a variável de região
provider "aws" {
  region = var.aws_region
}

# 3. Criando a VPC Virtual Private Cloud(Rede Privada)
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.projeto_name}-vpc"
    Environment = "production"
  }
}

# Criando o Internet Gateway para dar saída para a internet
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.projeto_name}-igw"
  }
}

# Criando a Subnet Pública
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.projeto_name}-public-subnet"
  }
}

# Criando a Tabela de Roteamento para a Subnet Pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Representa toda a internet externo
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.projeto_name}-public-rt"
  }
}

# Associando a Subnet Pública à Tabela de Roteamento
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}