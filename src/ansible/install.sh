#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
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
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/ansible-community/ansible-build-data/tags | jq -r '.[0].name')"
fi

# set install path
if [ -z "${VENV_PATH:-}" ]; then
  VENV_PATH=/opt/ansible
fi

# install ansible
python3 -m venv "${VENV_PATH}"
"${VENV_PATH}/bin/pip" install --upgrade pip setuptools wheel
"${VENV_PATH}/bin/pip" install "ansible==${VERSION}"

# set install path
if [ -n "${DEPENDENCIES:-}" ]; then
  # ensure packages are separated by spaces
  DEPENDENCIES=$(printf '%s' "$DEPENDENCIES" | tr ',' ' ')
  "${VENV_PATH}/bin/pip" install $DEPENDENCIES
fi

# link ansible binaries into PATH
for bin in "${VENV_PATH}"/bin/ansible*; do
  ln -sf "${bin}" /usr/local/bin/
done
