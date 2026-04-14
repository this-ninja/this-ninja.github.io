#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI is not installed." >&2
  exit 1
fi

if gh auth status >/dev/null 2>&1; then
  gh auth status
  exit 0
fi

if [ -n "${GH_TOKEN:-}" ]; then
  gh auth status || true
  gh auth setup-git || true
  echo "GitHub CLI is using GH_TOKEN."
  exit 0
fi

gh auth login --git-protocol https --scopes "repo,read:org,workflow,codespace" --web
gh auth setup-git || true
gh auth status

