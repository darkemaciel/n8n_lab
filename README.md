## 🎯 Objetivo Principal

Criar um **ambiente local e isolado** usando Docker para estudar e desenvolver workflows de automação com n8n, integrando:

- ✅ **n8n** - Plataforma de automação visual e gratuita
- ✅ **Supabase Cloud** - Banco de dados PostgreSQL gerenciado e gratuito
- ✅ **Telegram** - Notificações e integração de chat
- ✅ **ngrok** - Túnel público para webhooks sem custos

Tudo rodando localmente no Docker, sem gastos com infraestrutura!

---

## 🛠️ Stack Tecnológico

| Componente | Função |
|-----------|--------|
| **Docker & Docker Compose** | Orquestração de containers |
| **n8n** | Plataforma de automação visual |
| **Supabase Cloud** | Banco de dados PostgreSQL gerenciado |
| **ngrok** | Túnel público para webhooks |
| **Telegram Bot API** | Integração de notificações |

**Opcional:**
- OpenAI API (para workflows com IA)
- Grok API (para workflows com IA)

---

## 📋 Tutorial

### Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- ✅ **Docker** ([Download](https://docs.docker.com/engine/install/))
- ✅ **Git** instalado
- ✅ **ngrok** instalado ([Download](https://ngrok.com/download) ou `sudo apt-get install ngrok`)
- ✅ **Conexão com internet**
- ✅ **Porta 5678 disponível** (n8n)

Verificar instalação:
```bash
docker --version
docker compose version
git --version
ngrok --version
```

### 1️⃣ Clone o Repositório

```bash
git clone <https://github.com/darkemaciel/n8n_lab.git>
cd n8n_lab
```

### 2️⃣ Crie o Arquivo `.env`

```bash
cp infra/.env.example infra/.env
```

### 3️⃣ Configure as Credenciais

Edite `infra/.env` com seus valores:

```bash
code infra/.env  # ou vim, nano, etc
```

#### 🔐 Obtendo Credenciais do Supabase

Para usar a conexão com o Supabase, siga estes passos:

1. Acesse seu projeto no [Supabase Dashboard](https://app.supabase.com)
2. No menu lateral, clique em **"Connect"** (ou ícone de conexão)
3. Na parte superior, altere o **Method** de **"Direct Connection"** para **"Session Pooler"**
4. Copie os seguintes valores (usando IPv4):
   - `Host` → Use como `SUPABASE_DB_HOST`
   - `Database` → Use como `SUPABASE_DB_NAME` 
   - `User` → Use como `SUPABASE_DB_USER` 
   - `Port` → Use como `SUPABASE_DB_PORT` 

**Nota:** Session Pooler é recomendado para aplicações que estabelecem muitas conexões simultâneas. Isso melhora a performance e evita limites de conexão.

**Obrigatório configurar:**
- `SUPABASE_DB_HOST` - Host do seu projeto Supabase (Session Pooler)
- `SUPABASE_DB_USER` - Usuário do banco
- `SUPABASE_DB_PASSWORD` - Senha do banco
- `SUPABASE_DB_PORT` - Porta do pooler
- `NGROK_AUTHTOKEN` - Token ngrok ([obter aqui](https://dashboard.ngrok.com/auth/your-authtoken))
- `N8N_PASSWORD` - Senha do n8n (mude de `CHANGE_ME`)
- `N8N_ENCRYPTION_KEY` - Gere uma nova: `openssl rand -hex 32`

### 4️⃣ Execute o Script de Inicialização

```bash
bash scripts/start.sh
```

O script automaticamente:
- ✅ Valida Docker e `.env`
- ✅ Inicia container n8n
- ✅ Inicia ngrok em background
- ✅ Atualiza `.env` com a URL pública do ngrok
- ✅ Exibe links de acesso

### 5️⃣ Acesse o n8n

**Credenciais:** `seu e-mail` / `<N8N_PASSWORD do .env>`

✅ **Pronto para usar!**

---

## 📝 O Que os Scripts Fazem

### `start.sh` - Iniciar Ambiente

```bash
bash scripts/start.sh
```

**Etapas:**
1. Valida se Docker está rodando
2. Valida se `.env` existe e tem NGROK_AUTHTOKEN
3. Faz pull das imagens Docker mais recentes
4. Inicia container n8n
5. Aguarda 5 segundos para o n8n inicializar
6. **Inicia ngrok em background** com port forwarding
7. Aguarda 4 segundos para ngrok estabelecer túnel
8. Busca URL pública do ngrok via API
9. **Atualiza automaticamente** `N8N_HOST` e `WEBHOOK_URL` no `.env`
10. Exibe pontos de acesso (local + público)

### `stop.sh` - Parar Ambiente

```bash
bash scripts/stop.sh
```

**Etapas:**
1. Para container n8n
2. Mata processo ngrok em background
3. Preserva volumes e dados

### `validate_workflows.sh` - Validar Workflows

```bash
bash scripts/validate_workflows.sh
```

**Etapas:**
1. Verifica se pasta `workflows/` existe
2. Encontra todos os arquivos `.json`
3. Valida sintaxe JSON de cada workflow
4. Reporta erros com nomes de arquivos

---

## 📂 Estrutura do Projeto

```
n8n_lab/
│
├── 📄 README.md                    ← Este arquivo
├── 📄 .gitignore                   ← Protege .env
│
├── 📁 infra/                       # Infraestrutura
│   ├── docker-compose.yml          # Serviços Docker (n8n)
│   ├── .env.example                # Template seguro
│   └── .env                        # Configuração (não versione!)
│
├── 📁 scripts/                     # Automação
│   ├── start.sh                    # Iniciar [+ngrok+auto-update .env]
│   ├── stop.sh                     # Parar [+kill ngrok]
│   └── validate_workflows.sh       # Validar JSONs
│
├── 📁 workflows/                   # Seus workflows aqui
│   ├── ingestion/                  # Integração de dados
│   ├── orchestration/              # Orquestração
│   ├── analytics/                  # Análise de dados
│   ├── ai/                         # Workflows com IA
│   └── experiments/                # Testes e experimentos
```

---

## 🚀 Próximos Passos

1. **Primeiro acesso:**
   - Acesse n8n via ngrok URL
   - Faça login com credenciais do `.env`
   - Explore a interface

2. **Criar workflow:**
   - Novo workflow → Adicione nodes
   - Configure integrações (Telegram, APIs, etc)
   - Teste com "Execute"

3. **Sincronizar com Telegram:**
   - Crie Bot no Telegram (@BotFather)
   - Configure token no workflow
   - Teste mensagens

4. **Documentar e organizar:**
   - Salve workflows em `workflows/<categoria>/`
   - Crie README para cada workflow
   - Execute validação: `bash scripts/validate_workflows.sh`