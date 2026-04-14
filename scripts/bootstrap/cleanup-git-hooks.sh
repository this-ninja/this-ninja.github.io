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

GIT_DIR="${REPO_ROOT}/.git"
HOOKS_DIR="${GIT_DIR}/hooks"

if [ ! -d "${HOOKS_DIR}" ]; then
  exit 0
fi

if [ -f "${REPO_ROOT}/.gitattributes" ]; then
  exit 0
fi

if command -v git-lfs >/dev/null 2>&1; then
  exit 0
fi

REMOVED=0
for hook in post-checkout post-commit post-merge pre-push; do
  HOOK_PATH="${HOOKS_DIR}/${hook}"

  if [ ! -f "${HOOK_PATH}" ]; then
    continue
  fi

  if rg -q "git lfs" "${HOOK_PATH}"; then
    rm -f "${HOOK_PATH}"
    REMOVED=1
    log "Removed stale Git LFS hook: ${hook}"
  fi
done

if [ "${REMOVED}" -eq 1 ] && [ "${QUIET}" = false ]; then
  echo "Git LFS hooks were removed because this repo does not currently use Git LFS."
fi
