# n8n Lab – Automation & Data Engineering Portfolio

Laboratório completo de **n8n** para estudar e demonstrar workflows de automação focados em engenharia de dados, analytics e integração com IA.

---

## 📚 Índice

1. [Stack Tecnológico](#stack-tecnológico)
2. [Pré-requisitos](#pré-requisitos)
3. [Instalação Rápida (5 minutos)](#instalação-rápida--5-minutos)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Usando o Ambiente](#usando-o-ambiente)
6. [Criando e Validando Workflows](#criando-e-validando-workflows)
7. [Segurança](#segurança)
8. [Troubleshooting](#troubleshooting)

---

## Stack Tecnológico

| Componente | Versão | Função |
|-----------|--------|--------|
| **n8n** | Latest | Plataforma de automação |
| **PostgreSQL** | 16 | Banco de dados principal |
| **pgAdmin** | Latest | Interface admin do banco |
| **Docker** | v2+ | Orquestração de containers |
| **Docker Compose** | v2+ | Gerenciamento de serviços |

**APIs Opcionais:**
- OpenAI (para workflows com IA)
- Grok (para workflows com IA)

---

## Pré-requisitos

Antes de começar, certifique-se de ter:

- ✅ **Docker** instalado ([Download](https://docs.docker.com/engine/install/))
- ✅ **Docker Compose** v2+ (`docker compose version`)
- ✅ **Git** instalado
- ✅ **Conexão com internet** (para pull de imagens)
- ✅ **Portas disponíveis:** 5678 (n8n), 5432 (PostgreSQL), 5050 (pgAdmin)

### Verificar Instalação

```bash
# Docker
docker --version

# Docker Compose
docker compose version

# Git
git --version
```

---

## Instalação Rápida (5 minutos)

### 1️⃣ Clonar o Repositório

```bash
git clone <seu-repositorio>
cd n8n_lab
```

### 2️⃣ Copiar Arquivo de Configuração

```bash
cp infra/.env.example infra/.env
```

### 3️⃣ Configurar Credenciais

Edite `infra/.env` com suas senhas:

```bash
# Opção 1: Usar seu editor favorito
vim infra/.env
# ou
code infra/.env  # VS Code
```

Altere os seguintes valores de `change_me` para senhas fortes:

```dotenv
# PostgreSQL
POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=sua_senha_segura_aqui    # ⚠️ MUDE ISSO!

# pgAdmin
PGADMIN_EMAIL=seu_email@example.com        # ⚠️ MUDE ISSO!
PGADMIN_PASSWORD=sua_senha_segura          # ⚠️ MUDE ISSO!

# n8n Authentication
N8N_USER=admin
N8N_PASSWORD=sua_senha_segura              # ⚠️ MUDE ISSO!

# APIs (opcional - preencha quando necessário)
OPENAI_API_KEY=sua_chave_openai
GROK_API_KEY=sua_chave_grok
```

### 4️⃣ Iniciar os Serviços

```bash
bash scripts/start.sh
```

O script irá:
- ✅ Validar se Docker está rodando
- ✅ Validar se `.env` existe
- ✅ Atualizar imagens Docker
- ✅ Iniciar containers
- ✅ Aguardar serviços ficarem prontos
- ✅ Exibir links de acesso

### 5️⃣ Acessar os Serviços

Quando tudo estiver pronto, acesse:

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| **n8n** | http://localhost:5678 | admin / `<N8N_PASSWORD>` |
| **pgAdmin** | http://localhost:5050 | `<PGADMIN_EMAIL>` / `<PGADMIN_PASSWORD>` |

✅ **Pronto!** Você está online com n8n rodando!

---

## Estrutura do Projeto

```
n8n_lab/
│
├── 📄 README.md                    ← Você está aqui!
├── 📄 .gitignore                   ← Protege .env
│
├── 📁 infra/                       # Configurações de infraestrutura
│   ├── docker-compose.yml          # Definição dos serviços
│   ├── .env.example                # Template (copiar para .env)
│   └── .env                        # Configuração real (não versione!)
│
├── 📁 scripts/                     # Scripts de automação
│   ├── start.sh                    # Iniciar ambiente
│   ├── stop.sh                     # Parar ambiente
│   ├── validate_workflows.sh       # Validar workflows
│   ├── setup.sh                    # Setup automático
│   └── manage_workflows.sh         # Gerenciar workflows
│
├── 📁 workflows/                   # Seus workflows
│   ├── ingestion/                  # Integração de dados
│   ├── orchestration/              # Orquestração
│   ├── analytics/                  # Análise de dados
│   ├── ai/                         # Workflows com IA
│   └── experiments/                # Experimentação
│
└── 📁 docs/
    └── architecture.md             # Arquitetura do projeto
```

---

## Usando o Ambiente

### Iniciar Serviços

```bash
bash scripts/start.sh
```

### Parar Serviços

```bash
bash scripts/stop.sh
```

### Ver Status dos Containers

```bash
docker compose -f infra/docker-compose.yml ps
```

### Ver Logs

```bash
# Todos os serviços
docker compose -f infra/docker-compose.yml logs -f

# Apenas n8n
docker compose -f infra/docker-compose.yml logs -f n8n

# Apenas PostgreSQL
docker compose -f infra/docker-compose.yml logs -f postgres
```

### Conectar ao Banco de Dados Manualmente

```bash
docker exec -it n8n_postgres psql -U n8n -d n8n
```

### Validar Workflows

```bash
bash scripts/validate_workflows.sh
```

---

## Criando e Validando Workflows

### Passo 1: Criar Workflow em n8n

1. Acesse: http://localhost:5678
2. Login com: `admin` / `<N8N_PASSWORD>`
3. Clique em **"+"** ou **"New"** para criar novo workflow
4. Arraste e solte nós (nodes) de componentes
5. Conecte os nós conforme necessário
6. Clique **"Execute Workflow"** para testar

### Passo 2: Exportar Workflow

1. No menu superior, clique em **⋮** (três pontos)
2. Selecione **"Download"**
3. Salve o arquivo JSON

### Passo 3: Organizar em Pastas

Organize seus workflows por categoria:

```bash
# Exemplo de estrutura
workflows/
├── ingestion/
│   └── api_to_database/
│       ├── workflow.json
│       └── README.md
├── analytics/
│   └── data_summary/
│       ├── workflow.json
│       └── README.md
└── ai/
    └── chat_processor/
        ├── workflow.json
        └── README.md
```

### Passo 4: Documentar Workflow

Crie um `README.md` em cada pasta de workflow:

```markdown
# Nome do Workflow

## Descrição
Breve explicação do que faz.

## Entrada
O que o workflow recebe.

## Saída
O que o workflow retorna.

## Dependências
APIs ou recursos necessários.

## Como Usar
Instruções de uso.
```

### Passo 5: Validar Estrutura

```bash
bash scripts/validate_workflows.sh
```

Isso verifica se todos os JSONs são válidos.

---

## Variáveis de Ambiente

### Arquivo `.env`

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `POSTGRES_DB` | n8n | Nome do banco de dados |
| `POSTGRES_USER` | n8n | Usuário PostgreSQL |
| `POSTGRES_PASSWORD` | ⚠️ change_me | Senha PostgreSQL |
| `PGADMIN_EMAIL` | admin@n8nlab.com | Email do pgAdmin |
| `PGADMIN_PASSWORD` | ⚠️ change_me | Senha do pgAdmin |
| `N8N_USER` | admin | Usuário do n8n |
| `N8N_PASSWORD` | ⚠️ change_me | Senha do n8n |
| `N8N_HOST` | localhost | Host do n8n |
| `N8N_PORT` | 5678 | Porta do n8n |
| `OPENAI_API_KEY` | your_key_here | Chave OpenAI (opcional) |
| `GROK_API_KEY` | your_key_here | Chave Grok (opcional) |

---

## Segurança

### ✅ Boas Práticas Implementadas

- ✅ `.env` está no `.gitignore` - não será versionado
- ✅ `.env.example` como template seguro
- ✅ Docker daemon validado antes de iniciar
- ✅ Healthchecks em todos os serviços
- ✅ Senhas criptografadas no banco

### ⚠️ Importante

1. **NUNCA commite `.env` real** no Git
2. **Use senhas fortes** (mínimo 12 caracteres)
3. **Mude todos os valores padrão** (`change_me`)
4. **Faça backup regularmente** do banco de dados

### Backup do Banco de Dados

```bash
# Fazer backup
docker exec n8n_postgres pg_dump -U n8n n8n > backup_$(date +%Y%m%d).sql

# Restaurar backup
docker exec -i n8n_postgres psql -U n8n n8n < backup_YYYYMMDD.sql
```

---

## Troubleshooting

### "Docker: command not found"

**Solução:** Instale Docker Desktop ou Docker Engine
- [Download Docker](https://docs.docker.com/engine/install/)

### "Permission denied" nos scripts

**Solução:** Dar permissão de execução
```bash
chmod +x scripts/*.sh
```

### "Porta 5678 já está em uso"

**Solução:** Encontrar e matar o processo
```bash
# Linux/Mac
lsof -i :5678
kill -9 <PID>

# Windows
netstat -ano | findstr :5678
taskkill /PID <PID> /F
```

### "n8n não consegue conectar ao PostgreSQL"

**Solução:** Reiniciar com limpeza
```bash
bash scripts/stop.sh
docker compose -f infra/docker-compose.yml down -v
bash scripts/start.sh
```

### "Não consigo fazer login no n8n"

**Solução:** Verificar credenciais
1. Confirme a senha em `infra/.env`
2. Certifique-se que n8n está `healthy`: `docker ps`
3. Veja logs: `docker compose -f infra/docker-compose.yml logs n8n`

### "Erro ao conectar ao pgAdmin"

**Solução:** Verificar configuração
1. Confirme credenciais em `infra/.env`
2. Certifique-se que pgAdmin está `healthy`: `docker ps`
3. Aguarde 10 segundos para pgAdmin inicializar

### Erro genérico

**Solução:** Verificar logs completos
```bash
docker compose -f infra/docker-compose.yml logs -f
```

---

## Comandos Úteis

### Setup e Inicialização

```bash
# Copiar configuração
cp infra/.env.example infra/.env

# Iniciar ambiente
bash scripts/start.sh

# Parar ambiente
bash scripts/stop.sh

# Parar e remover volumes (limpeza completa)
docker compose -f infra/docker-compose.yml down -v
```

### Validação

```bash
# Validar workflows
bash scripts/validate_workflows.sh

# Ver status dos containers
docker ps

# Ver versões
docker --version
docker compose version
```

### Gerenciamento de Workflows

```bash
# Listar workflows
bash scripts/manage_workflows.sh list

# Validar arquivo JSON
bash scripts/manage_workflows.sh validate workflows/seu_workflow.json
```

### Debug

```bash
# Ver logs em tempo real
docker compose -f infra/docker-compose.yml logs -f

# Conectar ao PostgreSQL
docker exec -it n8n_postgres psql -U n8n -d n8n

# Executar comando no container n8n
docker exec -it n8n bash
```

---

## Próximos Passos

1. **Hoje:**
   - [ ] Copiar `.env.example` → `.env`
   - [ ] Editar `.env` com suas senhas
   - [ ] Executar `bash scripts/start.sh`
   - [ ] Acessar http://localhost:5678

2. **Esta Semana:**
   - [ ] Criar primeiro workflow
   - [ ] Exportar e salvar em `workflows/`
   - [ ] Documentar workflow
   - [ ] Validar estrutura

3. **Próximas Semanas:**
   - [ ] Implementar workflows de produção
   - [ ] Integrar com APIs (OpenAI, Grok)
   - [ ] Fazer backups regularmente
   - [ ] Documentar tudo

---

## Referências

- [Documentação n8n](https://docs.n8n.io/)
- [Docker Documentation](https://docs.docker.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

## Contribuindo

Para adicionar novos workflows:

1. Crie pasta em `workflows/<categoria>/`
2. Exporte workflow como JSON
3. Salve em `workflows/<categoria>/seu-workflow/workflow.json`
4. Crie `README.md` documentando o workflow
5. Faça commit e push (sem `.env`!)

---

## Licença

Este projeto é fornecido como está para fins educacionais.

---

## Suporte

Se encontrar problemas:

1. **Verifique logs:** `docker compose -f infra/docker-compose.yml logs -f`
2. **Consulte Troubleshooting** acima
3. **Valide `.env`:** Certifique-se de ter copiado e editado corretamente

---

**Última atualização:** 20 de janeiro de 2026  
**Status:** ✅ Pronto para Produção  
**Versão:** 1.0
