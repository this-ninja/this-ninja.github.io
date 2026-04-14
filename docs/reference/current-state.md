# Current State

This repository currently provides the bootstrap, workflow, and documentation baseline for this-ninja.github.io work developed from either GitHub Codespaces or WSL.

## What This Repo Is Today

`this-ninja.github.io` currently serves as:

- a GitHub-hosted source repository
- a reference point for Codespaces and WSL bootstrap for this repo
- a shared operator surface for humans and agents

## Control Plane Split

The current ownership model is:

- GitHub
  - source control
  - pull requests
  - Codespaces
  - repo-local agent and MCP configuration
- Local operator environments
  - Codespaces
  - WSL
  - CLI authentication and day-to-day scripting

When the `boards` module is enabled, Azure Boards owns planning and work management for that repo.

## Primary Entry Points

Use these before inventing new flows:

- `bash scripts/bootstrap/check-prereqs.sh`
- `bash scripts/bootstrap/env-report.sh`
- `bash scripts/bootstrap/login-github.sh`
- `bash scripts/bootstrap/login-azure.sh`
- `bash scripts/bootstrap/setup-wsl.sh`

## Current Environment Contract

The current repo-local defaults are:

- `APP_SHORT_NAME=this-ninja.github.io`

The supported configuration path uses platform-managed secrets and variables.

If the `boards` module is enabled, also use:

- `AZURE_DEVOPS_ORG`
- `AZURE_DEVOPS_PROJECT`
- `bash scripts/bootstrap/login-ado.sh`
- `bash scripts/bootstrap/verify-boards-crud.sh`
- `bash scripts/boards/show-work-item.sh <id>`
- `bash scripts/boards/start-work-item.sh <id>`
- `bash scripts/boards/resolve-work-item.sh <id>`
- `bash scripts/boards/close-work-item.sh <id>`

## Read First

When starting a fresh session:

1. Read `AGENTS.md`
2. Read this page
3. Read `docs/platform/repo-contract.md`
4. Run `bash scripts/bootstrap/check-prereqs.sh`
5. Run `bash scripts/bootstrap/env-report.sh`
6. If the repo uses the `boards` module, confirm the active work item before changing repo files
7. Use `docs/runbooks/session-restart-checklist.md` when chat history or local context was lost
