#!/bin/bash

# Setup script para n8n Lab
# Automatiza configuração inicial do ambiente

set -e

echo "🔧 n8n Lab Setup Script"
echo "======================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Verificar dependencies
echo "📋 Checking dependencies..."
echo ""

# Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found${NC}"
    echo "Please install Docker: https://docs.docker.com/engine/install/"
    exit 1
else
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✅ Docker:${NC} $DOCKER_VERSION"
fi

# Docker Compose
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker Compose not found${NC}"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
else
    COMPOSE_VERSION=$(docker compose version 2>/dev/null || echo "Not found")
    echo -e "${GREEN}✅ Docker Compose:${NC} $COMPOSE_VERSION"
fi

echo ""

# 2. Verificar .env
echo "🔐 Checking .env configuration..."
echo ""

if [ ! -f "infra/.env" ]; then
    echo -e "${YELLOW}⚠️  infra/.env not found${NC}"
    read -p "Create from .env.example? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp infra/.env.example infra/.env
        echo -e "${GREEN}✅ Created infra/.env${NC}"
        echo ""
        echo -e "${YELLOW}📝 Please edit infra/.env with your credentials:${NC}"
        echo "   - POSTGRES_PASSWORD"
        echo "   - PGADMIN_PASSWORD"
        echo "   - N8N_PASSWORD"
        echo "   - API Keys (OpenAI, Grok)"
        echo ""
        read -p "Press enter when done editing..."
    else
        echo -e "${RED}❌ Cannot proceed without .env${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ infra/.env exists${NC}"
fi

echo ""

# 3. Criar estrutura de workflows
echo "📁 Creating workflows structure..."
echo ""

DIRS=("ingestion" "orchestration" "analytics" "ai" "experiments")

for dir in "${DIRS[@]}"; do
    if [ ! -d "workflows/$dir" ]; then
        mkdir -p "workflows/$dir"
        echo -e "${GREEN}✅ Created${NC} workflows/$dir"
    else
        echo -e "${YELLOW}ℹ️  workflows/$dir already exists${NC}"
    fi
done

echo ""

# 4. Dar permissão aos scripts
echo "🔑 Setting script permissions..."
echo ""

chmod +x scripts/*.sh
echo -e "${GREEN}✅ Scripts have execution permissions${NC}"

echo ""

# 5. Resumo
echo "🎉 Setup complete!"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Edit infra/.env with your credentials"
echo "2. Run: bash scripts/start.sh"
echo "3. Access n8n at http://localhost:5678"
echo ""
echo "For detailed guide, see: DEPLOYMENT_GUIDE.md"
