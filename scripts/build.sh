#!/bin/bash

function error_and_exit {
  echo "error: $1" >&2
  exit 1
}

function purge_repo() {
  REPO="$1"
  [ "$REPO" = "" ] && error_and_exit "purge_repo() needs one argument (zero provided)"
  docker image ls --format json |
    jq -r '. | select(.Repository == "'"${REPO}"'" and .Tag != "latest") | .Tag' |
    sort -r |
    awk -v REPO="$REPO" '{ if (NR>1) printf("docker rmi %s:%s\n",REPO,$0) }' |
    bash -x
}

ROOTDIR="$(realpath $(dirname "$0")/..)"
TS="$(date +%Y%m%d_%H%M%S)"
set -e -o pipefail

REPO="ghcr.io/sfmunoz/jails-base"
set -x
cd "${ROOTDIR}/base/docker"
docker build -t ${REPO}:${TS} -f Dockerfile.base .
docker tag ${REPO}:${TS} ${REPO}:latest
{ set +x; } 2>/dev/null
purge_repo "$REPO"

REPO="ghcr.io/sfmunoz/jails-claude-code-plain"
set -x
cd "${ROOTDIR}/tools/claude-code/docker/plain"
docker build -t ${REPO}:${TS} -f Dockerfile .
docker tag ${REPO}:${TS} ${REPO}:latest
{ set +x; } 2>/dev/null
purge_repo "$REPO"
