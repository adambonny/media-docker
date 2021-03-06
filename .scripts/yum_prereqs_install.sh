#!/usr/bin/env bash
set -euo pipefail

yum_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  if [[ "${NOREMOVE}" = "N" ]] ; then
    sudo yum -y remove docker docker-client \
      docker-common docker-latest \
      docker-latest-logrotate docker-logrotate \
      docker-selinux docker-engine-selinux \
      docker-engine \
      > /dev/null 2>&1 \
      || true
  fi

  run_sh "$SCRIPTDIR" "yum_install" \
    "curl" "git" "grep" "sed" "jq" \
    "newt" "httpd-tools"
}
