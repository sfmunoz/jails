#!/bin/bash

REPO="ghcr.io/sfmunoz/jails-base"
TS="$(date +%Y%m%d_%H%M%S)"

set -x -e -o pipefail

cd "$(dirname "$0")/.."

cd base/docker

docker build -t ${REPO}:${TS} -f Dockerfile.base .

docker tag ${REPO}:${TS} ${REPO}:latest

{ set +x; } 2>/dev/null

docker image ls --format json |
  jq -r '. | select(.Repository == "'"${REPO}"'" and .Tag != "latest") | .Tag' |
  sort -r |
  awk -v REPO="$REPO" '{ if (NR>1) printf("docker rmi %s:%s\n",REPO,$0) }' |
  bash -x
