# this-ninja.github.io

This repository is the working home for this-ninja.github.io development with GitHub-hosted source control and shared agent/operator workflows across Codespaces and WSL.

## Start Here

Read these first when you open the repo:

- `AGENTS.md`
- `docs/reference/current-state.md`
- `docs/platform/repo-contract.md`
- `docs/runbooks/agent-session-start.md`
- `docs/runbooks/boards-crud.md` when the boards module is enabled for your repo
- `docs/runbooks/session-restart-checklist.md` when you are recovering from a rebuilt environment or fresh chat

## What This Repo Provides

- GitHub Codespaces bootstrap for the local CLI toolchain
- WSL bootstrap for the same CLI toolchain and repo-aware shell startup
- GitHub CLI and Azure CLI configuration
- Optional Azure Boards helper scripts and CRUD verification through the `boards` module
- Session restart and handoff helpers for rebuilt environments
- Repo-local operating docs and agent instructions
- Shared MCP configuration for VS Code/Copilot and Codex

## Quick Start In Codespaces

1. Create a codespace for `main`.
2. Wait for the devcontainer to finish.
3. Run:

```bash
bash scripts/bootstrap/check-prereqs.sh
bash scripts/bootstrap/env-report.sh
bash scripts/bootstrap/login-github.sh
bash scripts/bootstrap/login-azure.sh
```

If the repo enables the `boards` module, also run:

```bash
bash scripts/bootstrap/login-ado.sh
bash scripts/bootstrap/verify-boards-crud.sh
```

## Quick Start In WSL

1. Clone the repo inside WSL.
2. Run:

```bash
bash scripts/bootstrap/setup-wsl.sh
```

3. Make sure any required platform-managed secrets or variables are available in your environment.
4. Open a new shell in the repo.
5. Run:

```bash
bash scripts/bootstrap/check-prereqs.sh
bash scripts/bootstrap/env-report.sh
```

## Required Secrets And Inputs

Use platform-managed secrets and variables such as GitHub Codespaces secrets and variables, GitHub Actions secrets and variables, or Azure Pipelines variables and secrets:

| Secret / Variable | Purpose |
|---|---|
| `GH_TOKEN` | GitHub CLI authentication |
| `AZURE_CLIENT_ID` | Azure service principal app id |
| `AZURE_CLIENT_SECRET` | Azure service principal secret |
| `AZURE_TENANT_ID` | Azure tenant id |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription selection |
| `APP_SHORT_NAME` | Defaults to `this-ninja.github.io` |

If the `boards` module is enabled, also provide:

| Secret / Variable | Purpose |
|---|---|
| `AZURE_DEVOPS_EXT_PAT` | Azure DevOps CLI authentication for Boards/project access |
| `AZURE_DEVOPS_ORG` | Repo-defined Azure DevOps organization for the boards module |
| `AZURE_DEVOPS_PROJECT` | Repo-defined Azure DevOps project for the boards module |
