#!/usr/bin/env sh
# shellcheck disable=SC2016

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ -n "${DEBUG:-}" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

ensure_nanolayer

nanolayer install devcontainer-feature "ghcr.io/nikaro/features/python"

# set options
PIPX_HOME="${PIPX_HOME:-"/opt/pipx"}"
VERSION=${VERSION:-"latest"}

# install
python3 -m venv "$PIPX_HOME"
if [ "$VERSION" = "latest" ]; then
  "$PIPX_HOME"/bin/pip install --no-cache-dir --disable-pip-version-check pipx
else
  "$PIPX_HOME"/bin/pip install --no-cache-dir --disable-pip-version-check "pipx==$VERSION"
fi
ln -sf "$PIPX_HOME"/bin/pipx /usr/local/bin/pipx

# configure permissions
chown -R "$_REMOTE_USER:" "$PIPX_HOME"

# setup shells
if [ -d "/etc/profile.d" ]; then
  {
    echo "export PIPX_HOME=\"$PIPX_HOME\""
    echo 'command -v pipx >/dev/null || export PATH="$PIPX_HOME/bin:$PATH"'
  } >/etc/profile.d/pipx.sh
fi
if [ -f "/etc/bash.bashrc" ]; then
  {
    echo "export PIPX_HOME=\"$PIPX_HOME\""
    echo 'command -v pipx >/dev/null || export PATH="$PIPX_HOME/bin:$PATH"'
  } >/etc/bash.bashrc
fi
if [ -f "/etc/zsh/zshrc" ]; then
  {
    echo "export PIPX_HOME=\"$PIPX_HOME\""
    echo 'command -v pipx >/dev/null || export PATH="$PIPX_HOME/bin:$PATH"'
  } >/etc/zsh/zshrc
fi
if [ -d "/etc/fish/conf.d" ]; then
  {
    echo "set -x PIPX_HOME \"$PIPX_HOME\""
    echo 'command -q pipx; or set -p fish_user_paths $PIPX_HOME/bin'
  } >/etc/fish/conf.d/pipx.fish
fi
export PATH="$PIPX_HOME/bin:$PATH"

remove_nanolayer
