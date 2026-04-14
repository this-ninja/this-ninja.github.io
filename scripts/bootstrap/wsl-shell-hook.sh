#!/usr/bin/env bash

if [ -z "${REPOTEMPLATEDEV_REPO_ROOT:-}" ]; then
  return 0 2>/dev/null || exit 0
fi

case "${PWD}/" in
  "${REPOTEMPLATEDEV_REPO_ROOT}/"|"${REPOTEMPLATEDEV_REPO_ROOT}/"*)
    ;;
  *)
    return 0 2>/dev/null || exit 0
    ;;
esac

# shellcheck source=scripts/bootstrap/repo-env.sh
source "${REPOTEMPLATEDEV_REPO_ROOT}/scripts/bootstrap/repo-env.sh"

if [ "${REPOTEMPLATEDEV_SESSION_INIT_DONE:-0}" != "1" ]; then
  export REPOTEMPLATEDEV_SESSION_INIT_DONE=1
  bash "${REPOTEMPLATEDEV_REPO_ROOT}/scripts/bootstrap/session-init.sh" --quiet || true
fi
