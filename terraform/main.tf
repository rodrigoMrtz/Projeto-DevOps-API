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

# Criando o Security Group para a instância EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.projeto_name}-ec2-sg"
  description = "Security Group para o servidor da API"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.projeto_name}-ec2-sg"
  }
}
# Regra de Entrada: Permitir tráfego HTTP (porta 80) de qualquer lugar
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Allow HTTP traffic from anywhere"
}
# Regra de Entrada: Permitir tráfego SSH (porta 22) de qualquer lugar
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Allow SSH traffic from anywhere"
}

# Regra de Saída: Permitir que o servidor acesse a internet
resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" #-1 significa todos os protocolos
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Allow all egress traffic"
}

# Criando o Key Pair para acessar a instância EC2
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.projeto_name}-key"
  public_key = var.ssh_public_key
}

# Criando a Instância EC2 (Servidor Virtual) para hospedar a API 
resource "aws_instance" "web_server" {
  ami                         = "ami-0c7217cdde317cfec" # ID da AMI (Amazon Machine Image) para a instância
  instance_type               = "t3.micro"              # Tipo da instância (ex: t2.micro, t3.micro, etc.)
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true # Atribuir um IP público à instância
  key_name                    = aws_key_pair.ec2_key.key_name

  # Configurando o User Data para inicializar a instância com um script para instalar o Docker
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "${var.projeto_name}-api-server"
  }
}
