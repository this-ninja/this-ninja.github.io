#!/usr/bin/env bash

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap currently supports Debian/Ubuntu environments only." >&2
  exit 1
fi

SUDO=""
if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

apt_install() {
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y --no-install-recommends "$@"
}

safe_apt_update() {
  if $SUDO apt-get update -qq; then
    return
  fi

  if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
    echo "Falling back to the Ubuntu apt sources because a third-party source failed..." >&2
    $SUDO apt-get update \
      -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/ubuntu.sources \
      -o Dir::Etc::sourceparts=/dev/null \
      -o APT::Get::List-Cleanup=0 \
      -qq
    return
  fi

  $SUDO apt-get update \
    -o Dir::Etc::sourcelist=/etc/apt/sources.list \
    -o Dir::Etc::sourceparts=/dev/null \
    -o APT::Get::List-Cleanup=0 \
    -qq
}

ensure_base_packages() {
  safe_apt_update
  apt_install \
    bash-completion \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    lsb-release \
    ripgrep \
    software-properties-common \
    unzip \
    wget
}

ensure_github_cli() {
  if command -v gh >/dev/null 2>&1; then
    return
  fi

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null 2>&1
  $SUDO chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | $SUDO tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  safe_apt_update
  apt_install gh
}

ensure_azure_cli() {
  if command -v az >/dev/null 2>&1; then
    return
  fi

  curl -sL https://aka.ms/InstallAzureCLIDeb | $SUDO bash
}

ensure_node() {
  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    return
  fi

  apt_install nodejs npm
}

echo "==> Installing base packages..."
ensure_base_packages

echo "==> Ensuring GitHub CLI..."
ensure_github_cli

echo "==> Ensuring Azure CLI..."
ensure_azure_cli

echo "==> Ensuring Node.js..."
ensure_node

echo "==> Tooling install complete."
