# Azure Boards CRUD Runbook

This runbook explains the Azure Boards helper scripts in this repo and the raw `az boards` commands they wrap or complement.

## Preferred Helper Scripts

```bash
bash scripts/boards/show-work-item.sh <work-item-id>
bash scripts/boards/start-work-item.sh <work-item-id>
bash scripts/boards/resolve-work-item.sh <work-item-id>
bash scripts/boards/close-work-item.sh <work-item-id>
```

## Bootstrap And Verification

Before using Azure Boards from the CLI:

```bash
bash scripts/bootstrap/check-prereqs.sh
bash scripts/bootstrap/login-ado.sh
```

To verify read/write access end to end:

```bash
bash scripts/bootstrap/verify-boards-crud.sh
```

The CRUD verification script:

1. creates a Feature
2. creates a Requirement
3. creates a Task
4. links them in a parent-child chain
5. updates the Requirement
6. moves the Task to `Active`
7. queries all created items
8. optionally deletes the test items

## Common Raw CLI Commands

Create a work item:

```bash
az boards work-item create \
  --title "My this-ninja.github.io task" \
  --type Task \
  --org https://dev.azure.com/this-ninja \
  --project this-ninja.github.io
```

Update a work item:

```bash
az boards work-item update --id <id> --title "Updated title"
az boards work-item update --id <id> --description "Updated description"
az boards work-item update --id <id> --state Active
```

Query work items:

```bash
az boards query \
  --wiql "SELECT [System.Id],[System.Title],[System.State] FROM WorkItems WHERE [System.TeamProject] = 'this-ninja.github.io' ORDER BY [System.ChangedDate] DESC" \
  --org https://dev.azure.com/this-ninja \
  --project this-ninja.github.io
```

Delete a work item:

```bash
az boards work-item delete --id <id> --org https://dev.azure.com/this-ninja --project this-ninja.github.io --yes
```

## Troubleshooting

- If `az boards` commands fail immediately, run `bash scripts/bootstrap/login-ado.sh`.
- If project access fails, confirm `AZURE_DEVOPS_EXT_PAT` has the required Azure Boards scope and that the target project is `this-ninja / this-ninja.github.io`.
- If state transitions differ from expectations, check the Azure Boards process template for that work item type.
