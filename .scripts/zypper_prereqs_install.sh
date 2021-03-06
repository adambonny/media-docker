#!/usr/bin/env bash
set -euo pipefail

zypper_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  if [[ "${NOREMOVE}" = "N" ]] ; then
    sudo zypper -n rm docker docker-engine docker.io \
      > /dev/null 2>&1 \
      || true
  fi

  run_sh "$SCRIPTDIR" "zypp_install" \
    "curl" "git-core" "grep" "sed" "jq" \
    "newt" "apache2-utils"
}
