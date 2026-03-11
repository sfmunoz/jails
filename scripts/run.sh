#!/bin/bash
IMAGE="ghcr.io/sfmunoz/jails-claude-code-plain:latest"
if [ "$JAILS_ROOT" = "1" ]; then
  set -x
  exec docker run -it --rm --name claude-code -u root:root "${IMAGE}" bash
else
  set -x
  exec docker run -it --rm --name claude-code -v .:/workspace "${IMAGE}" bash
fi
