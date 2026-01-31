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

echo "🚀 Starting ngrok tunnel..."
# Load environment variables
source infra/.env

if [ -z "$NGROK_AUTHTOKEN" ]; then
    echo "❌ Error: NGROK_AUTHTOKEN not found in infra/.env"
    exit 1
fi

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ Error: ngrok is not installed!"
    echo ""
    echo "📥 Install ngrok:"
    echo "   1. Download from: https://ngrok.com/download"
    echo "   2. Extract and add to PATH"
    echo "   3. Or install via package manager:"
    echo "      Ubuntu/Debian: sudo apt-get install ngrok"
    echo "      macOS: brew install ngrok"
    exit 1
fi

# Kill any existing ngrok processes
pkill -f "ngrok http" 2>/dev/null || true
sleep 1

# Start ngrok in background
echo "   Starting ngrok (auth token: ${NGROK_AUTHTOKEN:0:10}...)"
ngrok http 5678 --authtoken "$NGROK_AUTHTOKEN" > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!
sleep 4

# Check if ngrok started successfully
if ! kill -0 $NGROK_PID 2>/dev/null; then
    echo "❌ Error: ngrok failed to start"
    echo "   Logs:"
    cat /tmp/ngrok.log
    exit 1
fi

# Fetch ngrok public URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -z "$NGROK_URL" ]; then
    echo "⚠️  Warning: Could not fetch ngrok URL yet. Retrying..."
    sleep 2
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | head -1 | cut -d'"' -f4)
fi

if [ -z "$NGROK_URL" ]; then
    echo "⚠️  Warning: Could not fetch ngrok URL. Check if ngrok started correctly."
    echo "    Logs: cat /tmp/ngrok.log"
    echo "    Dashboard: http://localhost:4040"
else
    echo "✅ ngrok tunnel established: $NGROK_URL"
    
    # Update .env with ngrok URL
    NGROK_HOST=$(echo "$NGROK_URL" | sed 's|https://||' | sed 's|http://||')
    sed -i "s|^N8N_HOST=.*|N8N_HOST=$NGROK_HOST|" infra/.env
    sed -i "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" infra/.env
    
    echo "📝 Updated infra/.env with ngrok URL"
fi

# Verificar se todos os containers estão rodando
echo "🔍 Checking container status..."
if docker compose -f infra/docker-compose.yml --env-file infra/.env ps | grep -q "running"; then
    echo ""
    echo "✅ n8n Lab started successfully!"
    echo ""
    echo "📋 Access points:"
    echo "   n8n (local):  http://localhost:5678"
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"[^"]*' | head -1 | cut -d'"' -f4)
    if [ ! -z "$NGROK_URL" ]; then
        echo "   n8n (public): $NGROK_URL"
    fi
    echo "   ngrok UI:     http://localhost:4040"
    echo ""
    echo "🔗 Webhook URL configured in n8n: $(grep "WEBHOOK_URL=" infra/.env | cut -d'=' -f2)"
    echo ""
    echo "ℹ️  Use 'bash scripts/stop.sh' to stop all services."
else
    echo "⚠️  Some services may not be running. Check logs with: docker compose -f infra/docker-compose.yml logs"
    exit 1
fi