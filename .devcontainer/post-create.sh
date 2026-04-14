#!/usr/bin/env bash

set -euo pipefail

echo "==> [post-create] Installing repo tooling..."
bash scripts/bootstrap/install-linux-tooling.sh

echo "==> [post-create] Generating MCP client configs..."
node scripts/generate-mcp-configs.js

echo "==> [post-create] Complete."
