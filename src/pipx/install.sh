#!/usr/bin/env sh
# shellcheck disable=SC2016

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

ensure_nanolayer

nanolayer install devcontainer-feature "ghcr.io/nikaro/features/python"
set +o errexit
. /etc/profile
set -o errexit

# set options
PIPX_HOME="${PIPX_HOME:-"/usr/local/share/pipx"}"
PIPX_BIN_DIR="${PIPX_BIN_DIR:-"/usr/local/bin"}"
PIPX_MAN_DIR="${PIPX_MAN_DIR:-"/usr/local/share/man"}"
VERSION=${VERSION:-"latest"}

# install
python3 -m venv "$PIPX_HOME"
if [ "$VERSION" = "latest" ]; then
  "$PIPX_HOME"/bin/pip install --no-cache-dir --disable-pip-version-check pipx
else
  "$PIPX_HOME"/bin/pip install --no-cache-dir --disable-pip-version-check "pipx==$VERSION"
fi

# configure permissions
chown -R "$_REMOTE_USER:" "$PIPX_HOME"

# setup shells
if [ -d "/etc/profile.d" ]; then
  {
    echo "export PIPX_HOME=\"$PIPX_HOME\""
    echo "export PIPX_BIN_DIR=\"$PIPX_BIN_DIR\""
    echo "export PIPX_MAN_DIR=\"$PIPX_MAN_DIR\""
    echo 'export PATH="$PIPX_HOME/bin:$PATH"'
    echo 'export PATH="$PIPX_BIN_DIR:$PATH"'
  } >/etc/profile.d/pipx.sh
fi
if [ -d "/etc/fish/conf.d" ]; then
  {
    echo "set -x PIPX_HOME \"$PIPX_HOME\""
    echo "set -x PIPX_BIN_DIR \"$PIPX_BIN_DIR\""
    echo "set -x PIPX_MAN_DIR \"$PIPX_MAN_DIR\""
    echo 'set -p fish_user_paths $PIPX_HOME/bin'
    echo 'set -p fish_user_paths $PIPX_BIN_DIR'
  } >/etc/fish/conf.d/pipx.fish
fi

remove_nanolayer
