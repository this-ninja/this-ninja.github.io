#!/usr/bin/env bash

set -euo pipefail

bash scripts/bootstrap/session-init.sh --quiet || true

echo ""
echo "┌──────────────────────────────────────────────┐"
echo "│  this-ninja.github.io bootstrap status              │"
echo "└──────────────────────────────────────────────┘"
echo ""

if gh auth status >/dev/null 2>&1; then
  echo "  GitHub CLI     : authenticated"
else
  echo "  GitHub CLI     : not authenticated"
fi

if az account show >/dev/null 2>&1; then
  echo "  Azure CLI      : authenticated"
else
  echo "  Azure CLI      : not authenticated"
fi

echo ""
echo "  Quick start:"
echo "    bash scripts/bootstrap/check-prereqs.sh"
echo "    bash scripts/bootstrap/env-report.sh"
echo ""
