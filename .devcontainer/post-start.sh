#!/usr/bin/env bash

set -euo pipefail

bash scripts/bootstrap/session-init.sh --quiet || true
AUTH_LOGIN_TIMEOUT_SECONDS="${POST_START_AUTH_LOGIN_TIMEOUT_SECONDS:-20}"

warn() {
  echo "WARNING: $*" >&2
}

github_authenticated() {
  command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1
}

azure_authenticated() {
  command -v az >/dev/null 2>&1 && az account show >/dev/null 2>&1
}

run_login_if_needed() {
  local label="$1"
  local check_function="$2"
  local login_script="$3"

  if "${check_function}"; then
    echo "  ${label}: already authenticated"
    return 0
  fi

  echo "  ${label}: not authenticated; running ${login_script}"

  if [ ! -f "${login_script}" ]; then
    warn "${login_script} is missing; skipping ${label} login."
    return 0
  fi

  if ! command -v timeout >/dev/null 2>&1; then
    warn "timeout is not available; skipping automatic ${label} login to avoid blocking post-start. You can retry with: bash ${login_script}"
    return 0
  fi

  local status=0
  timeout --foreground "${AUTH_LOGIN_TIMEOUT_SECONDS}s" bash "${login_script}" || status=$?
  if [ "${status}" -eq 0 ]; then
    return 0
  fi

  if [ "${status}" -eq 124 ] || [ "${status}" -eq 137 ]; then
    warn "${label} login did not complete within ${AUTH_LOGIN_TIMEOUT_SECONDS}s. You can retry with: bash ${login_script}"
  else
    warn "${label} login did not complete. You can retry with: bash ${login_script}"
  fi
}

print_final_auth_status() {
  echo ""
  echo "Final auth status:"

  if github_authenticated; then
    echo "  GitHub CLI     : authenticated"
  else
    echo "  GitHub CLI     : not authenticated"
  fi

  if azure_authenticated; then
    echo "  Azure CLI      : authenticated"
  else
    echo "  Azure CLI      : not authenticated"
  fi
}

run_readiness_check() {
  local check_script="$1"

  if [ ! -f "${check_script}" ]; then
    warn "${check_script} is missing; skipping."
    return 0
  fi

  if ! bash "${check_script}"; then
    warn "${check_script} reported a problem; review the output above and rerun it when ready."
  fi
}

echo ""
echo "┌──────────────────────────────────────────────┐"
echo "│  this-ninja.github.io bootstrap status              │"
echo "└──────────────────────────────────────────────┘"
echo ""

run_login_if_needed "GitHub CLI     " github_authenticated "scripts/bootstrap/login-github.sh"
run_login_if_needed "Azure CLI      " azure_authenticated "scripts/bootstrap/login-azure.sh"

print_final_auth_status

echo ""
echo "Readiness checks:"
run_readiness_check "scripts/bootstrap/check-prereqs.sh"
run_readiness_check "scripts/bootstrap/env-report.sh"
echo ""
