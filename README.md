# API Python Orquestrada com Docker Compose, PostgreSQL, Terraform e AWS EC2

<p align="center">

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions)

</p>

![CI Pipeline](https://github.com/rodrigoMrtz/Projeto-DevOps-API/actions/workflows/ci.yml/badge.svg)

Este projeto demonstra o ciclo completo de Engenharia de DevOps para a criação, conteinerização, automação de testes/build (CI) e deploy (CD) de uma API baseada em FastAPI integrada a um banco de dados relacional PostgreSQL.

Desenvolvido com foco em automação de infraestrutura, segurança de credenciais e esteiras de implantação automatizadas.

---

# Arquitetura e Fluxo do Ambiente

O ecossistema foi desenhado para rodar de forma isolada dentro de uma instância EC2 na AWS, utilizando Docker Compose para orquestrar os serviços em uma rede privada.

Arquitetura de Rede e Portas:

                ┌────────────────────────┐
                │   Acesso Externo       │
                │ (Internet / Navegador) │
                └───────────┬────────────┘
                            │
                            │ Porta 3000 (Liberada via Terraform Security Group)
                            ▼
        ┌────────────────────────────────────┐
        │          Instancia AWS EC2         │
        │                                    │
        │   ┌────────────────────────┐       │
        │   │    Docker Container    │       │
        │   │        web-api         │       │
        │   │   Porta Interna: 3000  │       │
        │   │   Exposta Host: 3000   │       │
        │   └───────────┬────────────┘       │
        │               │                    │
        │               │ Rede api_network   │
        │               │ Porta 5432         │
        │               ▼                    │
        │   ┌────────────────────────┐       │
        │   │    Docker Container    │       │
        │   │          db            │       │
        │   │     PostgreSQL 15      │       │
        │   └────────────────────────┘       │
        └────────────────────────────────────┘



## Serviços Orquestrados

### web-api
Container responsável pela execução da API.
- Imagem base: rodrigomrtz/minha-api-devops:latest (Buildada via GitHub Actions).
- Framework: FastAPI (Python 3.11 baseado em Alpine Linux).

### db
Container responsável pela camada de persistência de dados.
- Imagem base oficial: postgres:15-alpine.
- Persistência: Configurado com Named Volumes (postgres_data) para evitar a perda de dados em caso de reinicialização ou destruição do container.
- Isolamento: Acessível externamente apenas via API dentro da rede isolada do Docker.

---

# Esteira de DevOps e Segurança

## 1. Proteção Local (Git Hooks)
O projeto conta com validações automatizadas antes do envio do código. O arquivo de pre-commit barra modificações que violem a sintaxe ou que deixem configurações de variáveis expostas antes de validar os arquivos do Terraform.

## 2. Integracao Continua (GitHub Actions)
Toda alteração unificada na branch principal dispara uma esteira automatizada que realiza:
- Autenticação criptografada no Docker Hub via Repository Secrets.
- Build isolado e otimizado da imagem Docker da API.
- Push da imagem gerada para o registro público sob a tag rodrigomrtz/minha-api-devops:latest.

## 3. Infraestrutura como Codigo (Terraform)
Toda a infraestrutura de nuvem na AWS (VPC, Subnets, Internet Gateway, Route Tables, Security Groups e Instância EC2) é declarada de forma imutável e escalável utilizando arquivos de configuração do Terraform. O provisionamento inicial do Docker e Docker Compose no Ubuntu ocorre automaticamente no boot da máquina via instruções de User Data.

## 4. Gerenciamento de Credenciais
Arquivos de ambiente (.env) estão explicitamente inclusos no .gitignore e .dockerignore. A API resgata as chaves em runtime por meio de injeções diretas passadas pelo ambiente do Docker Compose no servidor.

## 5. Práticas de Segurança em Redes (Security Groups)
> [!NOTE]  
> **Nota sobre Segurança de Acesso Remoto:** Para fins acadêmicos, de demonstração prática de habilidades e facilidade de manutenção no laboratório de estudos, o acesso SSH (Porta 22) no Security Group da EC2 foi configurado como aberto para o mundo (`0.0.0.0/0`). 
> 
> **Em um ambiente de produção real**, esta prática é altamente desencorajada. Para mitigar esse risco de segurança e restringir a superfície de ataque, aplicaríamos uma das seguintes abordagens:
> - Limitar o bloco CIDR de entrada estritamente para o IP corporativo confiável ou o IP público do operador.
> - Utilizar um **Bastion Host** (Jump Box) em uma Subnet Pública com o servidor da API isolado em uma Subnet Privada.
> - Implementar conexões seguras através do **AWS Systems Manager (SSM) Session Manager**, eliminando completamente a necessidade de abrir a porta 22 para a internet externa.

---

# Padrao de Commits
O projeto adota estritamente a especificação de Conventional Commits para manter o histórico de mudanças limpo e legível.

Exemplos:
- feat: adiciona automacao de volumes no postgres
- fix: corrige conflito de portas entre host e container
- docs: atualiza readme com arquitetura de rede da AWS

---

# Como Executar o Projeto

## Clonar o repositório

```bash
git clone https://github.com/rodrigoMrtz/Projeto-DevOps-API.git

cd Projeto-DevOps-API
```

---

## Configurar as variáveis de ambiente

```bash
cp .env.example .env
```

Edite o arquivo `.env` conforme necessário.

---

## Inicializar os containers

```bash
docker compose up -d
```

---

## Verificar os serviços

```bash
docker compose ps
```

---

## Logs da aplicação

```bash
docker compose logs -f web-api
```

---

## Parar os containers

```bash
docker compose down
```

---

# Acessando a Aplicação

API

```
http://localhost:3000
```

Swagger UI

```
http://localhost:3000/docs
```

OpenAPI

```
http://localhost:3000/openapi.json
```

---

# Variáveis de Ambiente

O projeto utiliza um arquivo `.env` baseado no modelo disponível em:

```text
.env.example
```

# Desenvolvido por
Rodrigo Martinez Ortiz
