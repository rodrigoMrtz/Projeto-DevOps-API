#!/bin/bash
# Script de automação para o User Data do Terraform
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
   echo "Aguardando outra instalação terminar..."
   sleep 5
done

echo "Iniciando automação do User Data..."

apt-get update -y

# Instala o Docker oficial e o Docker Compose v2
apt-get install -y docker.io docker-compose-v2

# Inicia e habilita o serviço do Docker
systemctl start docker
systemctl enable docker

# Garante que o usuário padrão 'ubuntu' fará parte do grupo do Docker
usermod -aG docker ubuntu

echo "✅ Automação concluída com sucesso!"