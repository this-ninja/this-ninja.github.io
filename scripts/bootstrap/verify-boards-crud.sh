#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/bootstrap/repo-env.sh
source "${SCRIPT_DIR}/repo-env.sh"

NO_CLEANUP=false
for arg in "$@"; do
  if [ "${arg}" = "--no-cleanup" ]; then
    NO_CLEANUP=true
  fi
done

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI is not installed." >&2
  exit 1
fi

if ! az extension show --name azure-devops >/dev/null 2>&1; then
  az extension add --name azure-devops --yes >/dev/null
fi

TIMESTAMP="$(date +"%Y-%m-%dT%H-%M-%S")"
FEATURE_TITLE="[Test] this-ninja.github.io Boards CRUD Feature ${TIMESTAMP}"
REQUIREMENT_TITLE="[Test] this-ninja.github.io Boards CRUD Requirement ${TIMESTAMP}"
TASK_TITLE="[Test] this-ninja.github.io Boards CRUD Task ${TIMESTAMP}"

echo "Creating feature..."
FEATURE_JSON="$(az boards work-item create --title "${FEATURE_TITLE}" --type Feature --org "${AZURE_DEVOPS_ORG_URL}" --project "${AZURE_DEVOPS_PROJECT}" -o json)"
FEATURE_ID="$(echo "${FEATURE_JSON}" | jq -r '.id')"

echo "Creating requirement..."
REQUIREMENT_JSON="$(az boards work-item create --title "${REQUIREMENT_TITLE}" --type Requirement --org "${AZURE_DEVOPS_ORG_URL}" --project "${AZURE_DEVOPS_PROJECT}" -o json)"
REQUIREMENT_ID="$(echo "${REQUIREMENT_JSON}" | jq -r '.id')"

az boards work-item relation add \
  --id "${REQUIREMENT_ID}" \
  --relation-type parent \
  --target-id "${FEATURE_ID}" \
  --org "${AZURE_DEVOPS_ORG_URL}" \
  -o none || true

echo "Creating task..."
TASK_JSON="$(az boards work-item create --title "${TASK_TITLE}" --type Task --org "${AZURE_DEVOPS_ORG_URL}" --project "${AZURE_DEVOPS_PROJECT}" -o json)"
TASK_ID="$(echo "${TASK_JSON}" | jq -r '.id')"

az boards work-item relation add \
  --id "${TASK_ID}" \
  --relation-type parent \
  --target-id "${REQUIREMENT_ID}" \
  --org "${AZURE_DEVOPS_ORG_URL}" \
  -o none || true

echo "Updating requirement and task..."
az boards work-item update \
  --id "${REQUIREMENT_ID}" \
  --description "Created by verify-boards-crud.sh at ${TIMESTAMP}" \
  --org "${AZURE_DEVOPS_ORG_URL}" \
  -o none

az boards work-item update \
  --id "${TASK_ID}" \
  --state Active \
  --org "${AZURE_DEVOPS_ORG_URL}" \
  -o none || true

echo "Querying created work items..."
WIQL="SELECT [System.Id],[System.Title],[System.WorkItemType],[System.State] FROM WorkItems WHERE [System.Id] IN (${FEATURE_ID},${REQUIREMENT_ID},${TASK_ID}) ORDER BY [System.Id]"
QUERY_JSON="$(az boards query --wiql "${WIQL}" --org "${AZURE_DEVOPS_ORG_URL}" --project "${AZURE_DEVOPS_PROJECT}" -o json)"
echo "${QUERY_JSON}" | jq -r '.[] | "ID:\(.id) Type:\(.fields["System.WorkItemType"]) State:\(.fields["System.State"]) Title:\(.fields["System.Title"])"'

echo ""
echo "Created work items:"
echo "  Feature     : ${FEATURE_ID}"
echo "  Requirement : ${REQUIREMENT_ID}"
echo "  Task        : ${TASK_ID}"

if [ "${NO_CLEANUP}" = true ]; then
  exit 0
fi

read -r -p "Delete the test items now? [y/N] " CLEANUP
if [[ "${CLEANUP}" =~ ^[Yy]$ ]]; then
  for id in "${TASK_ID}" "${REQUIREMENT_ID}" "${FEATURE_ID}"; do
    az boards work-item delete --id "${id}" --org "${AZURE_DEVOPS_ORG_URL}" --project "${AZURE_DEVOPS_PROJECT}" --yes -o none || true
  done
fi
