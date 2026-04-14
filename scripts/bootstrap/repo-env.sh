#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

export APP_SHORT_NAME="${APP_SHORT_NAME:-this-ninja.github.io}"
