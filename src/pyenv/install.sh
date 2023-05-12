#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${1:-}" = "DEBUG" ]; then
  set -o xtrace
  PYENV_DEBUG=1
  export PYENV_DEBUG
fi

# check requirements
command -v curl >/dev/null 2>&1 || {
  echo >&2 "curl is required but not installed. Aborting."
  exit 1
}
command -v jq >/dev/null 2>&1 || {
  echo >&2 "jq is required but not installed. Aborting."
  exit 1
}
command -v bash >/dev/null 2>&1 || {
  echo >&2 "bash is required but not installed. Aborting."
  exit 1
}
command -v git >/dev/null 2>&1 || {
  echo >&2 "git is required but not installed. Aborting."
  exit 1
}

# get latest pyenv version
if [ -z "${PYENV_GIT_TAG:-}" ]; then
  PYENV_GIT_TAG="$(curl -s https://api.github.com/repos/pyenv/pyenv/releases/latest | jq -r '.tag_name')"
  export PYENV_GIT_TAG
fi

# set install path
if [ -z "${PYENV_ROOT:-}" ]; then
  PYENV_ROOT=/opt/pyenv
  export PYENV_ROOT
fi

# install pyenv
ln -sf "${PYENV_ROOT}/bin/pyenv" /usr/local/bin/pyenv
curl https://pyenv.run | bash

# get latest python version
if [ -z "${PYTHON_VERSION:-}" ]; then
  PYTHON_VERSION="$(pyenv install -l | grep -v 'dev\|a\|rc\|-' | tail -n 1 | xargs)"
fi

# install python
pyenv install "${PYTHON_VERSION}"
pyenv global "${PYTHON_VERSION}"
find "$(pyenv root)/versions/$(pyenv version | awk '{print $1}')/bin" -type f -exec ln -sf {} /usr/local/bin/ \;
find "$(pyenv root)/versions/$(pyenv version | awk '{print $1}')/bin" -type l -exec ln -sf {} /usr/local/bin/ \;
