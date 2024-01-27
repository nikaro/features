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

nanolayer install devcontainer-feature "ghcr.io/nikaro/features/pyenv"

if [ "$(pyenv global)" = "system" ]; then
  # set options
  if [ -z "${PYTHON_VERSION:-}" ]; then
    PYTHON_VERSION=$(pyenv install -l | grep -v 'dev\|a\|rc\|-' | tail -n 1 | xargs)
  fi

  # install requirements
  if [ -x "/usr/bin/apt-get" ]; then
    REQUIREMENTS="build-essential libbz2-dev libffi-dev liblzma-dev libreadline-dev libsqlite3-dev libssl-dev zlib1g-dev"
  elif [ -x "/sbin/apk" ]; then
    REQUIREMENTS="build-base bzip2-dev libffi-dev libressl-dev libuuid readline-dev sqlite-dev xz-dev zlib-dev"
  else
    err "unsupported distro"
  fi
  for package in $REQUIREMENTS; do
    pkg_install "$package"
  done

  # install
  pyenv install "$PYTHON_VERSION"
  pyenv global "$PYTHON_VERSION"

  # configure permissions
  chown -R "$_REMOTE_USER:" "$(pyenv root)"

  # remove installed requirements
  for package in $REQUIREMENTS; do
    pkg_remove "$package"
  done
fi

remove_nanolayer
