import os
from fastapi import FastAPI
from dotenv import load_dotenv

# Carrega as variáveis do arquivo .env
load_dotenv()

app = FastAPI(title="Minha API DevOps")

# Resgatando as variáveis de ambiente com segurança
ENVIRONMENT = os.getenv("APP_ENV", "production")
SECRET_KEY = os.getenv("API_SECRET_KEY")

@app.get("/")
def read_root():
    return {
        "status": "online",
        "ambiente": ENVIRONMENT,
        "mensagem": "API estruturada com sucesso para o Docker!"
    }

@app.get("/config")
def read_config():
    # Simulando a verificação de uma chave sem expô-la por completo na tela
    if SECRET_KEY:
        masked_key = f"{SECRET_KEY[:4]}...{SECRET_KEY[-4:]}" if len(SECRET_KEY) > 8 else "***"
        return {"chave_carregada": True, "token_preview": masked_key}
    return {"chave_carregada": False}