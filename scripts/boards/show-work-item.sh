#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/boards/common.sh
source "${SCRIPT_DIR}/common.sh"

require_work_item_id "$@"
ensure_ado_ready

WORK_ITEM_JSON="$(show_work_item_json "$1")"
echo "${WORK_ITEM_JSON}" | jq '{
  id: .id,
  type: .fields["System.WorkItemType"],
  title: .fields["System.Title"],
  state: .fields["System.State"],
  reason: .fields["System.Reason"],
  assignedTo: (.fields["System.AssignedTo"].displayName // .fields["System.AssignedTo"].uniqueName // null),
  url: ._links.html.href
}'

