#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ -z "${DEBUG:-}" ]; then
  set -o xtrace
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
command -v python3 >/dev/null 2>&1 || {
  echo >&2 "python3 is required but not installed. Aborting."
  exit 1
}

# get latest version
if [ -z "${POETRY_VERSION:-}" ]; then
  POETRY_VERSION="$(curl -s https://api.github.com/repos/python-poetry/poetry/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi
export POETRY_VERSION

# set install path
if [ -z "${POETRY_HOME:-}" ]; then
  POETRY_HOME=/opt/poetry
fi
export POETRY_HOME

curl -sSL https://install.python-poetry.org | python3 -
ln -sf "${POETRY_HOME}/bin/poetry" /usr/local/bin/poetry
