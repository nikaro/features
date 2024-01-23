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
if [ -z "${ANSIBLE_VERSION:-}" ]; then
  ANSIBLE_VERSION="$(curl -s https://api.github.com/repos/ansible-community/ansible-build-data/tags | jq -r '.[0].name')"
fi

# set install path
if [ -z "${ANSIBLE_HOME:-}" ]; then
  ANSIBLE_HOME=/opt/ansible
fi

# install ansible
python3 -m venv "${ANSIBLE_HOME}"
"${ANSIBLE_HOME}/bin/pip" install --upgrade pip setuptools wheel
"${ANSIBLE_HOME}/bin/pip" install "ansible==${ANSIBLE_VERSION}"

# set install path
if [ -n "${ANSIBLE_DEPENDENCIES:-}" ]; then
  # ensure packages are separated by spaces
  ANSIBLE_DEPENDENCIES=$(printf '%s' "$ANSIBLE_DEPENDENCIES" | tr ',' ' ')
  "${ANSIBLE_HOME}/bin/pip" install $ANSIBLE_DEPENDENCIES
fi

# link ansible binaries into PATH
for bin in "${ANSIBLE_HOME}"/bin/ansible*; do
  ln -sf "${bin}" /usr/local/bin/
done
