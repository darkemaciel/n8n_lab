#!/bin/bash
set -e

echo "🔍 Validating workflows folder structure..."
echo ""

# Verificar se a pasta workflows existe
if [ ! -d "workflows" ]; then
    echo "❌ Error: 'workflows' directory not found!"
    exit 1
fi

# Contar JSONs encontrados
WORKFLOW_COUNT=$(find workflows -name "*.json" 2>/dev/null | wc -l)

if [ $WORKFLOW_COUNT -eq 0 ]; then
    echo "⚠️  No workflow files found in 'workflows' directory."
    echo "ℹ️  This is expected if you haven't created workflows yet."
    echo ""
    echo "Expected structure:"
    echo "  workflows/"
    echo "  ├── ingestion/"
    echo "  ├── orchestration/"
    echo "  ├── analytics/"
    echo "  ├── ai/"
    echo "  └── experiments/"
    echo ""
    exit 0
fi

# Validar cada JSON
ERROR_COUNT=0
echo "📋 Found $WORKFLOW_COUNT workflow file(s):"
echo ""

find workflows -name "*.json" | while read wf; do
    if python3 -m json.tool "$wf" > /dev/null 2>&1; then
        echo "✅ $wf (valid JSON)"
    else
        echo "❌ $wf (invalid JSON)"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done

if [ $ERROR_COUNT -gt 0 ]; then
    echo ""
    echo "❌ Validation failed: $ERROR_COUNT file(s) with invalid JSON format."
    exit 1
else
    echo ""
    echo "✅ All workflows validated successfully!"
fi