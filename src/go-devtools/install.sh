#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

ensure_nanolayer
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-delve" --option debug="${DEBUG:-}" --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-gomodifytags" --option debug="${DEBUG:-}" --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-goplay" --option debug="${DEBUG:-}" --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-gopls" --option debug="${DEBUG:-}" --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-gotests" --option debug="${DEBUG:-}" --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-impl" --option debug="${DEBUG:-}" --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-pkg-staticcheck" --option debug="${DEBUG:-}" --option keep=true
remove_nanolayer
