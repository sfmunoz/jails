#!/bin/bash
IMAGE="ghcr.io/sfmunoz/jails-claude-code-plain:latest"
if [ "$JAILS_ROOT" = "1" ]; then
  set -x
  exec docker run -it --rm --name claude-code -u root:root "${IMAGE}" bash
else
  HOME_JAILS="${HOME}/.jails"
  set -x
  mkdir -p "${HOME_JAILS}"
  rm -rf "${HOME_JAILS}/.local"
  ln -s ../jails_local "${HOME_JAILS}/.local"
  exec docker run -it --rm --name claude-code -v "${HOME_JAILS}:/home/jails:rw" -v ".:/workspace:rw" "${IMAGE}" bash
fi
