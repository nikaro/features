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
  --option package="github.com/golangci/golangci-lint/cmd/golangci-lint" \
  --option debug="${DEBUG:-}"
remove_nanolayer
