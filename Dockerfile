# 1. Baixa uma imagem oficial do Python baseada no Alpine Linux
FROM python:3.11-alpine

# 2. Define o diretório onde a aplicação vai morar dentro do container
WORKDIR /app

# 3. Copia o arquivo de dependências para dentro do container
COPY requirements.txt .

# 4. Instala as dependências diretamente no Linux do container
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copia o restante do código do projeto (app.py, .env.example, etc.)
COPY . .

# 6. Informa a porta que o container vai liberar 
EXPOSE 3000

# 7. Comando que inicializa a API quando o container ligar
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "3000"]