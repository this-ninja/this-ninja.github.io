#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI is not installed." >&2
  exit 1
fi

if ! az extension show --name azure-devops >/dev/null 2>&1; then
  az extension add --name azure-devops --yes >/dev/null
fi

az devops configure --defaults \
  organization="${AZURE_DEVOPS_ORG_URL}" \
  project="${AZURE_DEVOPS_PROJECT}" \
  >/dev/null

if az devops project show --org "${AZURE_DEVOPS_ORG_URL}" --project "${AZURE_DEVOPS_PROJECT}" -o table; then
  exit 0
fi

if [ -z "${AZURE_DEVOPS_EXT_PAT:-}" ]; then
  echo "Azure DevOps access is not ready. Set AZURE_DEVOPS_EXT_PAT or use an Azure identity with access to the org." >&2
else
  echo "Azure DevOps PAT is set, but project verification still failed." >&2
fi

exit 1

