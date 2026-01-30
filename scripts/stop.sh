#!/bin/bash
set -e

echo "🛑 Stopping n8n Lab..."

# Verificar se docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running!"
    exit 1
fi

# Parar e remover containers
if docker compose -f infra/docker-compose.yml ps | grep -q "docker-compose"; then
    docker compose -f infra/docker-compose.yml down
    echo "✅ n8n Lab stopped successfully."
    echo ""
    echo "📋 Containers and volumes are preserved for next startup."
else
    echo "ℹ️  No running n8n Lab services found."
fi