#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

ensure_nanolayer
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go" \
  --option debug="${DEBUG:-}"
reload_profile

VERSION=${VERSION:-"latest"}

# install package
go install "$PACKAGE@$VERSION"

remove_nanolayer
