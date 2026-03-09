#!/bin/bash

REPO="ghcr.io/sfmunoz/jails-base"
TS="$(date +%Y%m%d_%H%M%S)"

set -x -e -o pipefail

cd "$(dirname "$0")/.."

cd base/docker

docker build -t ${REPO}:${TS} -f Dockerfile.base .

docker tag ${REPO}:${TS} ${REPO}:latest
