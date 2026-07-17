#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./deploy.sh <resource-group-name>
# Example:
#   ./deploy.sh myResourceGroup

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <resource-group-name>"
  exit 1
fi

RESOURCE_GROUP="$1"
TEMPLATE_FILE="main.bicep"
PARAMETERS_FILE="parameters.json"

az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "$TEMPLATE_FILE" \
  --parameters "@$PARAMETERS_FILE"
