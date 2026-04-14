#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

echo ""
echo "this-ninja.github.io environment report"
echo ""
echo "Repo root            : ${REPO_ROOT:-unknown}"
echo "App short name       : ${APP_SHORT_NAME}"
echo ""

for cmd in gh az jq rg node npm; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    printf "%-20s %s\n" "${cmd}" "$(command -v "${cmd}")"
  else
    printf "%-20s %s\n" "${cmd}" "missing"
  fi
done

echo ""
if gh auth status >/dev/null 2>&1; then
  echo "GitHub auth          : ready"
else
  echo "GitHub auth          : not ready"
fi

if az account show >/dev/null 2>&1; then
  echo "Azure auth           : ready"
else
  echo "Azure auth           : not ready"
fi
