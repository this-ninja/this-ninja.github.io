# Agent Session Start

Use this checklist at the start of a fresh Codespaces session, a new WSL shell, or a new agent chat.

If prior chat history is gone, also use `docs/runbooks/session-restart-checklist.md`.

For a compact restart summary, run `bash scripts/bootstrap/session-snapshot.sh`.

## 1. Orient To The Repo

Read, in order:

1. `AGENTS.md`
2. `docs/reference/current-state.md`
3. `docs/platform/repo-contract.md`

## 2. Check Session Readiness

Run:

```bash
bash scripts/bootstrap/check-prereqs.sh
bash scripts/bootstrap/env-report.sh
```

If auth is missing, use:

```bash
bash scripts/bootstrap/login-github.sh
bash scripts/bootstrap/login-azure.sh
```

If the repo uses the `boards` module, also use:

```bash
bash scripts/bootstrap/login-ado.sh
bash scripts/bootstrap/verify-boards-crud.sh
```

## 3. Confirm Planning Context

Before editing repo files:

1. identify the active task or work item
2. confirm it is the right execution slice
3. if the repo uses the `boards` module, move it to `Active` when implementation actually begins
4. read any linked notes or repo docs relevant to that slice

## 4. Prefer Repo Entry Points

Use repo scripts before creating a new manual operator path.

Most common entrypoints:

- `bash scripts/bootstrap/check-prereqs.sh`
- `bash scripts/bootstrap/env-report.sh`
- `bash scripts/bootstrap/login-github.sh`
- `bash scripts/bootstrap/login-azure.sh`

If the `boards` module is enabled, the common entrypoints also include:

- `bash scripts/bootstrap/login-ado.sh`
- `bash scripts/boards/show-work-item.sh <id>`
- `bash scripts/boards/start-work-item.sh <id>`
- `bash scripts/boards/resolve-work-item.sh <id>`
- `bash scripts/boards/close-work-item.sh <id>`

## 5. Close Out Cleanly

When the slice is complete:

- update the owning tracker if the repo uses one
- if the repo uses the `boards` module, use `Resolved` when review or test is still needed
- if the repo uses the `boards` module, use `Closed` when no further review or test is required
- update the owning doc if the workflow or contract changed
