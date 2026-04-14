#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/boards/common.sh
source "${SCRIPT_DIR}/common.sh"

require_work_item_id "$@"
ensure_ado_ready
update_state "$1" "Active"
show_work_item_json "$1" | jq '{id: .id, title: .fields["System.Title"], state: .fields["System.State"], reason: .fields["System.Reason"]}'

