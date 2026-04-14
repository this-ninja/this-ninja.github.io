#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/../bootstrap/repo-env.sh"

usage_id_only() {
  echo "Usage: bash ${0##*/} <work-item-id>" >&2
}

require_work_item_id() {
  if [ "$#" -ne 1 ]; then
    usage_id_only
    exit 1
  fi

  case "$1" in
    ''|*[!0-9]*)
      echo "Work item id must be numeric." >&2
      exit 1
      ;;
  esac
}

ensure_ado_ready() {
  if ! command -v az >/dev/null 2>&1; then
    echo "Azure CLI not found. Run bash scripts/bootstrap/check-prereqs.sh" >&2
    exit 1
  fi

  if ! az extension show --name azure-devops >/dev/null 2>&1; then
    az extension add --name azure-devops --yes >/dev/null
  fi

  az devops configure --defaults \
    organization="${AZURE_DEVOPS_ORG_URL}" \
    project="${AZURE_DEVOPS_PROJECT}" \
    >/dev/null
}

show_work_item_json() {
  local work_item_id="$1"
  az boards work-item show \
    --id "${work_item_id}" \
    --org "${AZURE_DEVOPS_ORG_URL}" \
    --output json
}

update_state() {
  local work_item_id="$1"
  local target_state="$2"

  az boards work-item update \
    --id "${work_item_id}" \
    --state "${target_state}" \
    --org "${AZURE_DEVOPS_ORG_URL}" \
    --output none
}
