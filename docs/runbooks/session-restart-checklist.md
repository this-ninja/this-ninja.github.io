# Session Restart Checklist

Use this checklist after a Codespaces rebuild, a fresh agent chat, or any session where prior chat context is gone.

## 1. Rebuild Repo Context

Read these in order:

1. `AGENTS.md`
2. `docs/reference/current-state.md`
3. `docs/platform/repo-contract.md`
4. `docs/runbooks/agent-session-start.md`

These files define the operating contract, not the chat history.

## 2. Confirm Environment Readiness

Run:

```bash
bash scripts/bootstrap/check-prereqs.sh
bash scripts/bootstrap/env-report.sh
```

If any auth is missing, run only the needed login helpers:

```bash
bash scripts/bootstrap/login-github.sh
bash scripts/bootstrap/login-azure.sh
```

If the repo uses the `boards` module, also use:

```bash
bash scripts/bootstrap/login-ado.sh
bash scripts/bootstrap/verify-boards-crud.sh
```

## 3. Rehydrate Planning Context

Before changing repo files:

1. identify the active task or work item
2. if the repo uses the `boards` module and none exists, locate the parent Epic or Feature and create the smallest child execution slice
3. if the repo uses work-item states, move the implementation item to `Active` only when work actually begins
4. read any linked notes and the smallest owning repo doc for the behavior you will change

Preferred entrypoints:

```bash
```

If the `boards` module is enabled, common planning entrypoints also include:

```bash
bash scripts/boards/show-work-item.sh <id>
bash scripts/boards/start-work-item.sh <id>
```

## 4. Rebuild Working Memory

Capture the minimum state needed to continue:

- current branch and worktree status
- active task or work item id and title
- relevant docs, scripts, and files you expect to touch
- open questions, assumptions, and next verification step

Suggested commands:

```bash
bash scripts/bootstrap/session-snapshot.sh
git status --short --branch
git log --oneline --decorate -5
```

Record the restart state in `templates/session-handoff.md` if you are handing work to a future session.

## 5. Continue The Smallest Coherent Slice

Follow the repo contract while resuming:

- use repo helper scripts before ad hoc command chains
- update the smallest authoritative doc when workflow behavior changes
- keep scripts, docs, and agent guidance aligned
- include tracker references such as `AB#<work item id>` only when the work is Boards-backed

## 6. Close Out Cleanly

When the slice is complete:

1. update the owning tracker if the repo uses one
2. if the repo uses the `boards` module, move the item to `Resolved` when review or test is still required
3. if the repo uses the `boards` module, move it to `Closed` when no further review or test is required
4. leave parent items open until child items proving them are complete when the active tracker uses that hierarchy

## What This Checklist Does Not Replace

This checklist does not replace:

- module-specific planning systems when they are enabled
- repo docs as the workflow source of truth
- commit history and work items as the durable audit trail

It only makes restart and re-orientation faster.
