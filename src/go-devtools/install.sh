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
  --option package="github.com/go-delve/delve/cmd/dlv" \
  --option debug="${DEBUG:-}" \
  --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="github.com/fatih/gomodifytags" \
  --option debug="${DEBUG:-}" \
  --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="github.com/haya14busa/goplay/cmd/goplay" \
  --option debug="${DEBUG:-}" \
  --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="golang.org/x/tools/gopls" \
  --option debug="${DEBUG:-}" \
  --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="github.com/cweill/gotests/gotests" \
  --option debug="${DEBUG:-}" \
  --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="github.com/josharian/impl" \
  --option debug="${DEBUG:-}" \
  --option keep=true
nanolayer install devcontainer-feature "ghcr.io/nikaro/features/go-package" \
  --option package="honnef.co/go/tools/cmd/staticcheck" \
  --option debug="${DEBUG:-}" \
  --option keep=true
remove_nanolayer
