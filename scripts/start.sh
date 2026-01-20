#!/bin/bash
set -e

echo "🚀 Starting n8n Lab..."

# Verificar se .env existe
if [ ! -f "infra/.env" ]; then
    echo "❌ Error: infra/.env not found!"
    echo "Please copy infra/.env.example to infra/.env and configure it."
    echo "Command: cp infra/.env.example infra/.env"
    exit 1
fi

# Verificar se docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running!"
    exit 1
fi

echo "📦 Pulling latest images..."
docker compose -f infra/docker-compose.yml --env-file infra/.env pull

echo "🔧 Starting services..."
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d

echo "⏳ Waiting for services to be ready..."
sleep 5

# Verificar se todos os containers estão rodando
echo "🔍 Checking container status..."
if docker compose -f infra/docker-compose.yml --env-file infra/.env ps | grep -q "running"; then
    echo ""
    echo "✅ n8n Lab started successfully!"
    echo ""
    echo "📋 Access points:"
    echo "   n8n:     http://localhost:5678"
    echo "   pgAdmin: http://localhost:5050"
    echo ""
    echo "ℹ️  Use 'bash scripts/stop.sh' to stop all services."
else
    echo "⚠️  Some services may not be running. Check logs with: docker compose -f infra/docker-compose.yml logs"
    exit 1
fi