# 🐋 API Python Orquestrada com Docker Compose & PostgreSQL

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![PostgreSQL](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

Este projeto demonstra a criação, conteinerização e orquestração de uma API moderna em Python (FastAPI) integrada a um banco de dados relacional PostgreSQL. Desenvolvido com foco em boas práticas de **DevOps**, isolamento de ambiente e segurança de infraestrutura.

---

## 🏗️ Arquitetura e Fluxo do Ambiente

O ambiente foi desenhado para simular um cenário real de microsserviços localmente, utilizando o **Docker Compose** para isolar os serviços em uma rede interna privada (`api_network`).
---
[ Usuário / Navegador ]
│ (Porta 8080) |
▼
┌────────────────────────────────────────┐
│             Docker Network             │
│                                        │
│  ┌──────────────────┐                  │
│  │    Container     │                  │
│  │    web-api       │                  │
│  │   (FastAPI)      │                  │
│  └────────┬─────────┘                  │
│           │                            │
│           │ (Porta interna 5432)       │
│           ▼                            │
│  ┌──────────────────┐                  │
│  │    Container     │                  │
│  │       db         │                  │
│  │   (PostgreSQL)   │                  │
│  └──────────────────┘                  │
└────────────────────────────────────────┘
1. **`web-api`**: Container baseado na imagem leve `python:3.11-alpine`. Expõe a porta 8000 internamente, mapeada para a 8080 no host.
2. **`db`**: Container oficial `postgres:15-alpine`. Os dados são persistidos utilizando volumes do Docker para evitar perda de dados em caso de reinicialização do ambiente.

---

## 🔒 Boas Práticas de DevOps & Segurança Aplicadas

* **Isolamento de Credenciais:** Nenhuma chave secreta ou senha do banco de dados foi exposta no código-fonte. O projeto utiliza variáveis de ambiente injetadas via `python-dotenv` localmente e gerenciadas dinamicamente no Runtime pelo Docker Compose.
* **Otimização de Imagens:** Utilização de imagens base `Alpine Linux`, reduzindo drasticamente o tamanho final da imagem e a superfície de vulnerabilidades.
* **Higiene de Commits:** Utilização do padrão *Conventional Commits* para manter o histórico do Git limpo, documentado e profissional.
* **Arquivos de Ignorados (`.gitignore` e `.dockerignore`):** Configurados rigorosamente para impedir o vazamento de caches do Python, ambientes virtuais (`venv`) e arquivos locais sensíveis (`.env`).

---

## Como Rodar o Projeto Localmente

### Pré-requisitos
* Git instalado
* Docker e Docker Compose instalados e rodando

### 1. Clonar o repositório
```bash
git clone [https://github.com/rodrigoMrtz/Projeto-DevOps-API.git](https://github.com/rodrigoMrtz/Projeto-DevOps-API.git)
cd Projeto-DevOps-API
```
### 2. Configurar as Variáveis de Ambiente
O repositório possui um arquivo de exemplo. Crie uma cópia dele e configure suas chaves se desejar:
```
cp .env.example .env
```
### 3. Subir a Infraestrutura
Com apenas um comando, o Docker Compose vai baixar as imagens, criar a rede interna, configurar o banco de dados e iniciar a API:
```
docker compose up -d
```
A API estará disponível e pronta para receber requisições em: http://127.0.0.1:8080

### Comandos Úteis Utilizados
* docker compose ps - Verifica o status dos containers ativos.

* docker compose logs -f web-api - Acompanha os logs da API em tempo real.

* docker compose down - Desliga e remove os containers e redes criadas pelo Compose.

Desenvolvido por Rodrigo Martinez Ortiz