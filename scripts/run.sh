#!/bin/bash
IMAGE="ghcr.io/sfmunoz/jails-claude-code-plain:latest"
if [ -z "$HOME" ]; then
  echo "error: HOME is not defined" >&2
  exit 1
fi
_rel="${PWD#$HOME/}"
if [ "$_rel" = "$PWD" ] || [[ "$_rel" != */* ]] || [[ "$_rel" == */*/* ]]; then
  echo "error: must run from exactly two levels under \$HOME (e.g. \$HOME/foo/bar)" >&2
  exit 1
fi
unset _rel
if [ "$JAILS_ROOT" = "1" ]; then
  set -x
  exec docker run -it --rm --name claude-code -u root:root "${IMAGE}" "$@"
else
  HOME_JAILS="${HOME}/.jails"
  set -x
  mkdir -p "${HOME_JAILS}"
  rm -rf "${HOME_JAILS}/.local"
  ln -s ../jails_local "${HOME_JAILS}/.local"
  exec docker run -it --rm --name claude-code -v "${HOME_JAILS}:/home/jails:rw" -v ".:/workspace:rw" "${IMAGE}" "$@"
fi
