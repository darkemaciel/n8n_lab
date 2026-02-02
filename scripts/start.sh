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

# Verificar docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker daemon is not running!"
    exit 1
fi

echo "🚀 Starting ngrok tunnel..."

# Load env
source infra/.env

if [ -z "$NGROK_AUTHTOKEN" ]; then
    echo "❌ Error: NGROK_AUTHTOKEN not found in infra/.env"
    exit 1
fi

# Check ngrok
if ! command -v ngrok &> /dev/null; then
    echo "❌ Error: ngrok is not installed!"
    exit 1
fi

# Kill existing ngrok
pkill -f "ngrok http" 2>/dev/null || true
sleep 1

# Start ngrok
ngrok http 5678 --authtoken "$NGROK_AUTHTOKEN" > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!
sleep 4

if ! kill -0 $NGROK_PID 2>/dev/null; then
    echo "❌ Error: ngrok failed to start"
    cat /tmp/ngrok.log
    exit 1
fi

# Fetch URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Could not fetch ngrok URL"
    exit 1
fi

echo "✅ ngrok tunnel: $NGROK_URL"

NGROK_HOST=$(echo "$NGROK_URL" | sed 's|https://||' | sed 's|http://||')

# Update env BEFORE docker starts
sed -i "s|^N8N_HOST=.*|N8N_HOST=$NGROK_HOST|" infra/.env
sed -i "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" infra/.env

echo "📝 Updated infra/.env"

echo "🧹 Recreating containers..."

docker compose -f infra/docker-compose.yml --env-file infra/.env down
docker compose -f infra/docker-compose.yml --env-file infra/.env pull
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d --force-recreate

sleep 5

echo "🔍 Checking container status..."

if docker compose -f infra/docker-compose.yml ps | grep -q "running"; then
    echo ""
    echo "✅ n8n Lab started successfully!"
    echo ""
    echo "📋 Access points:"
    echo "   n8n (local):  http://localhost:5678"
    echo "   n8n (public): $NGROK_URL"
    echo "   ngrok UI:     http://localhost:4040"
    echo ""
    echo "🔗 Webhook URL: $NGROK_URL"
    echo ""
    echo "ℹ️  Use 'bash scripts/stop.sh' to stop services."
else
    echo "⚠️ Containers failed to start"
    docker compose -f infra/docker-compose.yml logs
    exit 1
fi
