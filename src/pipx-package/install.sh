#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

ensure_nanolayer

nanolayer install devcontainer-feature "ghcr.io/nikaro/features/pipx"
set +o errexit
. /etc/profile
set -o errexit

VERSION=${VERSION:-"latest"}
INJECTIONS=${INJECTIONS:-""}
INCLUDEDEPS=${INCLUDEDEPS:-"false"}

if ! pipx list --short | grep -q "$PACKAGE"; then
  if [ "$VERSION" = "latest" ]; then
    pipx_installation="$PACKAGE"
  else
    pipx_installation="$PACKAGE==$VERSION"
  fi

  # install main package
  # shellcheck disable=SC2089
  pipx_args='--pip-args="--no-cache-dir"'
  if [ "$INCLUDEDEPS" = "true" ]; then
    pipx_args="$pipx_args --include-deps"
  fi
  if [ "$DEBUG" = "true" ]; then
    pipx_args="$pipx_args --verbose"
  fi
  # shellcheck disable=SC2086,SC2090
  pipx install $pipx_args "$pipx_installation"

  # install injections (if provided)
  for injection in $INJECTIONS; do
    pipx inject "$PACKAGE" --pip-args="--no-cache-dir" "$injection"
  done

  # configure permissions
  chown -R "$_REMOTE_USER:" "$PIPX_HOME"
fi

remove_nanolayer
