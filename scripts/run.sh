#!/bin/bash

function error_and_exit {
  echo "error: $1" >&2
  exit 1
}

IMAGE="ghcr.io/sfmunoz/jails-claude-code-plain:latest"
[ -z "$HOME" ] && error_and_exit "HOME is not defined"
_rel="${PWD#$HOME/}"
if [ "$_rel" = "$PWD" ] || [[ "$_rel" != */* ]] || [[ "$_rel" == */*/* ]]; then
  error_and_exit "must run from exactly two levels under \$HOME (e.g. \$HOME/foo/bar)"
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
