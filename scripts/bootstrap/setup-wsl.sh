#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_DIR="${HOME}/.config/repotemplatedev"
BOOTSTRAP_ENV="${CONFIG_DIR}/bootstrap.env"
BASHRC_BLOCK_START="# >>> repotemplatedev bootstrap >>>"
BASHRC_BLOCK_END="# <<< repotemplatedev bootstrap <<<"

mkdir -p "${CONFIG_DIR}"

echo "==> Installing tooling for WSL..."
bash "${SCRIPT_DIR}/install-linux-tooling.sh"

cat > "${BOOTSTRAP_ENV}" <<EOF
export REPOTEMPLATEDEV_REPO_ROOT="${REPO_ROOT}"
EOF

if ! grep -Fq "${BASHRC_BLOCK_START}" "${HOME}/.bashrc"; then
  cat >> "${HOME}/.bashrc" <<'EOF'
# >>> repotemplatedev bootstrap >>>
if [ -f "${HOME}/.config/repotemplatedev/bootstrap.env" ]; then
  # shellcheck disable=SC1090
  source "${HOME}/.config/repotemplatedev/bootstrap.env"
  if [ -n "${REPOTEMPLATEDEV_REPO_ROOT:-}" ] && [ -f "${REPOTEMPLATEDEV_REPO_ROOT}/scripts/bootstrap/wsl-shell-hook.sh" ]; then
    # shellcheck disable=SC1090
    source "${REPOTEMPLATEDEV_REPO_ROOT}/scripts/bootstrap/wsl-shell-hook.sh"
  fi
fi
# <<< repotemplatedev bootstrap <<<
EOF
fi

echo "==> Running session init once..."
bash "${SCRIPT_DIR}/session-init.sh" || true

echo ""
echo "WSL bootstrap complete."
echo "Open a new shell in the repo after any required platform-managed secrets or variables are available."
