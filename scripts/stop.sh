#!/bin/bash
echo "🛑 Stopping n8n Lab..."
docker compose -f infra/docker-compose.yml down
echo "✅ n8n Lab stopped successfully."