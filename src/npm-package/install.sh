#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh
set +o errexit
. /etc/profile
set -o errexit

ensure_nanolayer

nanolayer install devcontainer-feature "ghcr.io/nikaro/features/node"

VERSION=${VERSION:-"latest"}

if ! npm list --short | grep -q "$PACKAGE"; then
  if [ "$VERSION" = "latest" ]; then
    npm_installation="$PACKAGE"
  else
    npm_installation="$PACKAGE@$VERSION"
  fi

  # install package
  npm install -g "$npm_installation"
fi

remove_nanolayer
