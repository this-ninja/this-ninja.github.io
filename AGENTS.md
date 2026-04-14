# Agent Operating Model

This repo is designed for humans, Codex, Copilot, and other agents to use the same workflow and the same source-of-truth docs.

## Source Of Truth

- `docs/reference/current-state.md` is the first-stop orientation page.
- `docs/platform/repo-contract.md` defines the normative repo contract.
- `README.md` explains the repo purpose, setup path, and key entrypoints.
- `docs/setup/getting-started.md` is the setup guide for Codespaces and WSL.
- `docs/runbooks/agent-session-start.md` is the new-session checklist.
- `docs/runbooks/boards-crud.md` is the Azure Boards CLI runbook when the `boards` module is enabled.

## Planning And Work Management

- Treat the repo's enabled planning system as the source of record.
- If the `boards` module is enabled, use the `Epic -> Feature -> Requirement -> Task` hierarchy.
- Start by identifying the active task or work item before making repo changes.
- If the repo uses work-item state transitions, move the item to `Active` only when implementation actually begins.
- Use repo helper scripts before ad hoc command sequences when a helper exists.
- If scope grows, add or refine work items instead of silently absorbing the work.

## Commit And Closeout Rules

- Include tracker references such as `AB#<work item id>` only when the repo uses that tracker.
- Prefer one coherent work item slice per commit.
- If the repo uses Boards states, move completed work to `Resolved` when review or test is still required.
- If the repo uses Boards states, move completed work to `Closed` when no further review or test is required.
- Leave parent work items open until the child items proving them are complete when the active tracker uses that hierarchy.

## Local Environment Rules

- Codespaces and WSL are the supported local operator environments.
- Secrets stay in platform-managed secret and variable stores, never in repo files.
- Use `bash scripts/bootstrap/check-prereqs.sh` and `bash scripts/bootstrap/env-report.sh` at the start of a fresh environment.
- Use `bash scripts/bootstrap/verify-boards-crud.sh` only when you need to prove read/write access to Azure Boards for the `boards` module.
