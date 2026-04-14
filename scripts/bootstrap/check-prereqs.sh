#!/usr/bin/env bash

set -euo pipefail

PASS=0
FAIL=0

check_cmd() {
  local name="$1"
  local cmd="$2"
  local version_flag="${3:---version}"

  if command -v "${cmd}" >/dev/null 2>&1; then
    local version
    version=$("${cmd}" "${version_flag}" 2>&1 | head -1) || version="version check failed"
    echo "  OK   ${name}: ${version}"
    PASS=$((PASS + 1))
  else
    echo "  MISS ${name}: not found"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "repotemplatedev prerequisite check"
echo ""

check_cmd "git" git "--version"
check_cmd "gh" gh "--version"
check_cmd "az" az "--version"
check_cmd "jq" jq "--version"
check_cmd "rg" rg "--version"
check_cmd "node" node "--version"
check_cmd "npm" npm "--version"

echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"

if [ "${FAIL}" -gt 0 ]; then
  exit 1
fi
