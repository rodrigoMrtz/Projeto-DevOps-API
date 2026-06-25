# 🐋 API Python Orquestrada com Docker Compose & PostgreSQL

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![PostgreSQL](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

Este projeto demonstra a criação, conteinerização e orquestração de uma API moderna em Python utilizando **FastAPI**, integrada ao banco de dados relacional **PostgreSQL**.

Desenvolvido com foco em boas práticas de:

- DevOps
- Segurança
- Isolamento de ambientes
- Conteinerização
- Organização profissional de projetos

---

# 🏗️ Arquitetura e Fluxo do Ambiente

O ambiente foi desenvolvido simulando um cenário real utilizando **Docker Compose**, onde os serviços são executados em containers isolados dentro de uma rede privada chamada:

```
api_network
```

Arquitetura:

```text
                ┌────────────────────────┐
                │ Usuário / Navegador    │
                └───────────┬────────────┘
                            │
                            │ Porta 8080
                            ▼

        ┌────────────────────────────────────┐
        │          Docker Network            │
        │          api_network               │
        │                                    │
        │                                    │
        │   ┌────────────────────────┐       │
        │   │       Container        │       │
        │   │        web-api         │       │
        │   │       FastAPI          │       │
        │   │                        │       │
        │   └───────────┬────────────┘       │
        │               │                    │
        │               │ Comunicação interna│
        │               │ Porta 5432         │
        │               ▼                    │
        │                                    │
        │   ┌────────────────────────┐       │
        │   │       Container        │       │
        │   │          db            │       │
        │   │     PostgreSQL 15      │       │
        │   │                        │       │
        │   └────────────────────────┘       │
        │                                    │
        └────────────────────────────────────┘
```

## Serviços

### 🚀 web-api

Container responsável pela API.

Características:

- Baseado em `python:3.11-alpine`
- Executa aplicação FastAPI
- Porta interna: `8000`
- Exposta no host como:

```
8080
```

---

### 🗄️ db

Container responsável pelo banco de dados.

Características:

- Imagem oficial:

```
postgres:15-alpine
```

- Dados persistentes usando volumes Docker
- Evita perda de dados após reinicialização dos containers

---

# 🔒 Boas Práticas de DevOps & Segurança

## 🔐 Isolamento de Credenciais

Nenhuma senha ou chave sensível fica versionada.

O projeto utiliza:

- `.env`
- Variáveis de ambiente
- Docker Compose

As configurações são carregadas somente em runtime.

---

## 📦 Otimização de Imagens

Utilização de imagens baseadas em:

```
Alpine Linux
```

Benefícios:

- Menor tamanho
- Menor superfície de ataque
- Inicialização mais rápida

---

## 📝 Padrão de Commits

Utilizado:

```
Conventional Commits
```

Exemplo:

```
feat: adiciona autenticação JWT

fix: corrige conexão com banco

docs: atualiza documentação
```

---

## 🚫 Arquivos Ignorados

Configurado:

- `.gitignore`
- `.dockerignore`

Bloqueando:

```
venv/
__pycache__/
.env
*.pyc
```

---

# 🚀 Como Rodar o Projeto Localmente

## Pré-requisitos

Instalar:

- Git
- Docker
- Docker Compose

---

# 1. Clonar o projeto

```bash
git clone https://github.com/rodrigoMrtz/Projeto-DevOps-API.git

cd Projeto-DevOps-API
```

---

# 2. Configurar variáveis de ambiente

Copie o arquivo de exemplo:

```bash
cp .env.example .env
```

Configure os valores necessários.

---

# 3. Subir infraestrutura

Execute:

```bash
docker compose up -d
```

O Docker irá:

- Criar a rede
- Criar containers
- Configurar PostgreSQL
- Iniciar API

---

# 🌐 Acessar API

A aplicação estará disponível em:

```
http://127.0.0.1:8080
```

Documentação automática FastAPI:

```
http://127.0.0.1:8080/docs
```

---

# 🛠️ Comandos Úteis

Ver containers ativos:

```bash
docker compose ps
```

---

Acompanhar logs da API:

```bash
docker compose logs -f web-api
```

---

Parar ambiente:

```bash
docker compose down
```

---

# 👨‍💻 Desenvolvido por

**Rodrigo Martinez Ortiz**