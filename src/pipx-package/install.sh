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
  verbose=$(if [ "$DEBUG" = "true" ]; then echo --verbose; fi)
  include_deps_cmd=$(if [ "$INCLUDEDEPS" = "true" ]; then echo --include-deps; fi)
  pipx install --pip-args '--no-cache-dir' "$include_deps_cmd" "$verbose" "$pipx_installation"

  # install injections (if provided)
  for injection in $INJECTIONS; do
    pipx inject "$PACKAGE" --pip-args '--no-cache-dir' "$injection"
  done

  # configure permissions
  chown -R "$_REMOTE_USER:" "$PIPX_HOME"
fi

remove_nanolayer
