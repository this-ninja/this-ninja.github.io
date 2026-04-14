#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI is not installed." >&2
  exit 1
fi

if az account show >/dev/null 2>&1; then
  az account show --query "{subscription:name,id:id,tenant:tenantId}" -o table
  exit 0
fi

if [ -n "${AZURE_CLIENT_ID:-}" ] && [ -n "${AZURE_CLIENT_SECRET:-}" ] && [ -n "${AZURE_TENANT_ID:-}" ]; then
  az login \
    --service-principal \
    --username "${AZURE_CLIENT_ID}" \
    --password "${AZURE_CLIENT_SECRET}" \
    --tenant "${AZURE_TENANT_ID}" \
    >/dev/null
else
  az login --use-device-code
fi

if [ -n "${AZURE_SUBSCRIPTION_ID:-}" ]; then
  az account set --subscription "${AZURE_SUBSCRIPTION_ID}"
fi

az account show --query "{subscription:name,id:id,tenant:tenantId}" -o table

