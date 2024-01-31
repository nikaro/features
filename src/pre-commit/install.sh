#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(
    curl -s https://api.github.com/repos/pre-commit/pre-commit/releases/latest |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )"
fi

# install
FILENAME="pre-commit-${VERSION}.pyz"
URL="https://github.com/pre-commit/pre-commit/releases/download/v${VERSION}/${FILENAME}"
curl -L "$URL" -o /usr/local/bin/pre-commit
chmod 0755 /usr/local/bin/pre-commit

# setup cache directory
mkdir -p "${_REMOTE_USER_HOME}/.cache/pre-commit"
chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "${_REMOTE_USER_HOME}/.cache"
