#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

echo ""
echo "repotemplatedev session snapshot"
echo ""
echo "Repo root            : ${REPO_ROOT:-${REPOTEMPLATEDEV_REPO_ROOT:-unknown}}"
echo "Current branch       : $(git -C "${REPO_ROOT:-${REPOTEMPLATEDEV_REPO_ROOT:-.}}" branch --show-current 2>/dev/null || echo "unknown")"
echo ""
echo "Orientation docs:"
echo "  - AGENTS.md"
echo "  - docs/reference/current-state.md"
echo "  - docs/platform/repo-contract.md"
echo "  - docs/runbooks/agent-session-start.md"
echo "  - docs/runbooks/session-restart-checklist.md"
echo "  - templates/session-handoff.md"
echo ""
echo "Git status:"
git -C "${REPO_ROOT:-${REPOTEMPLATEDEV_REPO_ROOT:-.}}" status --short --branch
echo ""
echo "Recent commits:"
git -C "${REPO_ROOT:-${REPOTEMPLATEDEV_REPO_ROOT:-.}}" log --oneline --decorate -5 || true
echo ""
echo "Next actions:"
echo "  1. Identify the change or task you will continue."
echo "  2. Fill in templates/session-handoff.md with current assumptions, touched files, and next verification."
echo "  3. If this repo uses the boards module, move the chosen work item to Active when work begins."
