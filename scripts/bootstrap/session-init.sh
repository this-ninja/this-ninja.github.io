#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

QUIET=false
if [ "${1:-}" = "--quiet" ]; then
  QUIET=true
fi

log() {
  if [ "${QUIET}" = false ]; then
    echo "$@"
  fi
}

warn() {
  echo "$@" >&2
}

cleanup_git_hooks() {
  if [ "${QUIET}" = true ]; then
    bash "${SCRIPT_DIR}/cleanup-git-hooks.sh" --quiet || true
  else
    bash "${SCRIPT_DIR}/cleanup-git-hooks.sh" || true
  fi
}

ensure_github_auth() {
  if ! command -v gh >/dev/null 2>&1; then
    warn "GitHub CLI is not installed."
    return 1
  fi

  if gh auth status >/dev/null 2>&1; then
    log "GitHub CLI is authenticated."
    gh auth setup-git >/dev/null 2>&1 || true
    return 0
  fi

  if [ -n "${GH_TOKEN:-}" ]; then
    gh auth status >/dev/null 2>&1 || true
    gh auth setup-git >/dev/null 2>&1 || true
    log "GitHub CLI is using GH_TOKEN."
    return 0
  fi

  warn "GH_TOKEN is not set; skipping GitHub auth bootstrap."
  return 1
}

ensure_azure_auth() {
  if ! command -v az >/dev/null 2>&1; then
    warn "Azure CLI is not installed."
    return 1
  fi

  if az account show >/dev/null 2>&1; then
    :
  elif [ -n "${AZURE_CLIENT_ID:-}" ] && [ -n "${AZURE_CLIENT_SECRET:-}" ] && [ -n "${AZURE_TENANT_ID:-}" ]; then
    log "Signing into Azure CLI with service principal..."
    az login \
      --service-principal \
      --username "${AZURE_CLIENT_ID}" \
      --password "${AZURE_CLIENT_SECRET}" \
      --tenant "${AZURE_TENANT_ID}" \
      >/dev/null
  else
    warn "Azure service-principal inputs are incomplete; skipping Azure auth bootstrap."
    return 1
  fi

  if [ -n "${AZURE_SUBSCRIPTION_ID:-}" ]; then
    az account set --subscription "${AZURE_SUBSCRIPTION_ID}" >/dev/null 2>&1 || true
  fi

  log "Azure CLI is authenticated."
  return 0
}

ensure_github_auth || true
ensure_azure_auth || true
cleanup_git_hooks
