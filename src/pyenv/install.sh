#!/usr/bin/env sh
# shellcheck disable=SC2016

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ -n "${DEBUG:-}" ]; then
  set -o xtrace
  PYENV_DEBUG=1
  export PYENV_DEBUG
fi

# shellcheck source=src/library_scripts.sh
. ./library_scripts.sh

# install requirements
pkg_install git

# set options
PYENV_ROOT="${PYENV_ROOT:-/opt/pyenv}"
PYENV_GIT_TAG="${PYENV_GIT_TAG:-"master"}"

# install
git_checkout https://github.com/pyenv/pyenv.git "$PYENV_ROOT" "$PYENV_GIT_TAG"
git_checkout https://github.com/pyenv/pyenv-doctor.git "$PYENV_ROOT/plugins/pyenv-doctor" master
git_checkout https://github.com/pyenv/pyenv-update.git "$PYENV_ROOT/plugins/pyenv-update" master
git_checkout https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv" master

# configure permissions
chown -R "$_REMOTE_USER:" "$PYENV_ROOT"

# setup shells
if [ -d "/etc/profile.d" ]; then
  {
    echo "export PYENV_ROOT=\"$PYENV_ROOT\""
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'command -v pyenv >/dev/null && eval "$(pyenv init -)"'
    echo 'command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"'
  } >/etc/profile.d/pyenv.sh
fi
if [ -d "/etc/fish/conf.d" ]; then
  {
    echo "set -x PYENV_ROOT \"$PYENV_ROOT\""
    echo 'command -q pyenv; or set -p fish_user_paths $PYENV_ROOT/bin'
    echo "command -q pyenv; and pyenv init - | source"
    echo "command -q pyenv; and pyenv virtualenv-init - | source"
  } >/etc/fish/conf.d/pyenv.fish
fi

# remove installed requirements
pkg_remove git
