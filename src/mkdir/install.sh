#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# exit if no directories are specified
[ -z "${DIRECTORIES:-}" ] && exit 0

# ensure directories are separated by spaces
DIRECTORIES=$(printf '%s' "$DIRECTORIES" | tr ',' ' ')

for directory in $DIRECTORIES; do
  # create directories
  mkdir -p "$directory"

  # change permissions of directories
  [ -z "${PERMISSIONS:-}" ] || chmod "$PERMISSIONS" "$directory"

  # change ownership of directories
  [ -z "${OWNER:-}" ] || chown "$OWNER" "$directory"
done
