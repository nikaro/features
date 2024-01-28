#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

ensure_nanolayer
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="golang.org/x/tools/gopls" \
  --option version="${VERSION:-}" \
  --option debug="${DEBUG:-}" \
  --option keep="${KEEP:-}"
if [ "${KEEP:-}" != "true" ]; then
  remove_nanolayer
fi
