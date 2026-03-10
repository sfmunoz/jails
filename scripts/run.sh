#!/bin/bash
set -x -e -o pipefail
exec docker run \
  -it \
  --rm \
  --name claude-code \
  -v .:/workspace \
  -u $(id -u):$(id -g) \
  ghcr.io/sfmunoz/jails-claude-code-plain \
  bash
