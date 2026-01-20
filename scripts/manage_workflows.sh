#!/bin/bash

# Script para gerenciar workflows (exportar/importar)
# Uso: bash scripts/manage_workflows.sh [export|import|list]

set -e

N8N_URL="http://localhost:5678"
N8N_USER="${N8N_USER:-admin}"
N8N_PASSWORD="${N8N_PASSWORD:-$(grep N8N_PASSWORD infra/.env | cut -d '=' -f2)}"

echo "📦 n8n Workflows Manager"
echo "========================"
echo ""

# Validar n8n disponível
check_n8n() {
    if ! curl -s "$N8N_URL/healthz" > /dev/null 2>&1; then
        echo "❌ n8n is not running!"
        echo "Start with: bash scripts/start.sh"
        exit 1
    fi
}

# Listar workflows
list_workflows() {
    echo "📋 Available workflows:"
    echo ""
    
    # Listar local
    if find workflows -name "*.json" 2>/dev/null | grep -q .; then
        echo "Local workflows:"
        find workflows -name "*.json" -type f | while read -r file; do
            size=$(du -h "$file" | cut -f1)
            echo "  - $file ($size)"
        done
    else
        echo "  (No local workflows yet)"
    fi
    
    echo ""
    echo "🔗 To see workflows in n8n:"
    echo "  1. Open http://localhost:5678"
    echo "  2. Navigate to Workflows menu"
}

# Exportar workflow
export_workflow() {
    local workflow_name="$1"
    
    if [ -z "$workflow_name" ]; then
        echo "❌ Usage: bash scripts/manage_workflows.sh export <workflow_name>"
        exit 1
    fi
    
    echo "📤 Exporting workflow: $workflow_name"
    
    check_n8n
    
    # Criar diretório se não existir
    mkdir -p workflows/exports
    
    echo "✅ Export workflow from n8n UI:"
    echo "  1. Open http://localhost:5678"
    echo "  2. Open workflow: $workflow_name"
    echo "  3. Click Menu (⋮) → Download"
    echo "  4. Save to: workflows/exports/$workflow_name.json"
}

# Importar workflow
import_workflow() {
    local workflow_file="$1"
    
    if [ -z "$workflow_file" ] || [ ! -f "$workflow_file" ]; then
        echo "❌ Workflow file not found: $workflow_file"
        exit 1
    fi
    
    echo "📥 Importing workflow: $workflow_file"
    
    check_n8n
    
    echo "✅ Import workflow to n8n:"
    echo "  1. Open http://localhost:5678"
    echo "  2. Click 'Open' → 'Import from file'"
    echo "  3. Select: $workflow_file"
    echo "  4. Click Save"
}

# Validar JSON
validate_json() {
    local file="$1"
    
    if python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "✅ Valid JSON"
        return 0
    else
        echo "❌ Invalid JSON"
        return 1
    fi
}

# Main
case "${1:-list}" in
    list)
        list_workflows
        ;;
    export)
        export_workflow "$2"
        ;;
    import)
        import_workflow "$2"
        ;;
    validate)
        if [ -z "$2" ]; then
            echo "❌ Usage: bash scripts/manage_workflows.sh validate <file.json>"
            exit 1
        fi
        echo "🔍 Validating: $2"
        validate_json "$2"
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        echo "Usage:"
        echo "  bash scripts/manage_workflows.sh list              # List workflows"
        echo "  bash scripts/manage_workflows.sh export <name>    # Export workflow"
        echo "  bash scripts/manage_workflows.sh import <file>    # Import workflow"
        echo "  bash scripts/manage_workflows.sh validate <file>  # Validate JSON"
        exit 1
        ;;
esac
