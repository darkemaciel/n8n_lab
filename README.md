# n8n Lab – Automation & Data Engineering Portfolio

This repository contains a complete local n8n lab used to study and demonstrate
automation workflows focused on data engineering, analytics and AI integration.

## Stack
- n8n
- Docker & Docker Compose
- PostgreSQL
- pgAdmin
- OpenAI / Grok APIs

## How to Run
```bash
cp infra/.env.example infra/.env
bash scripts/start.sh
n8n → http://localhost:5678
pgAdmin → http://localhost:5050
