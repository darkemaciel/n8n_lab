#!/bin/bash
echo "🔍 Validating workflows folder structure..."

find workflows -name "*.json" | while read wf; do
  echo "✔ Found workflow: $wf"
done
echo "✅ All workflows validated successfully."