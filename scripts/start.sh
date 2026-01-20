#!/bin/bash
echo "🚀 Starting n8n Lab..."
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
echo "✅ n8n Lab started successfully."