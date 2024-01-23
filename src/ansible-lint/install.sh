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
if [ -z "${ANSIBLE_LINT_VERSION:-}" ]; then
  ANSIBLE_LINT_VERSION="$(curl -s https://api.github.com/repos/ansible/ansible-lint/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi
export ANSIBLE_LINT_VERSION

# set install path
if [ -z "${ANSIBLE_LINT_HOME:-}" ]; then
  ANSIBLE_LINT_HOME=/opt/ansible-lint
fi
export ANSIBLE_LINT_HOME

python3 -m venv "${ANSIBLE_LINT_HOME}"
"${ANSIBLE_LINT_HOME}/bin/pip" install --upgrade pip setuptools wheel
"${ANSIBLE_LINT_HOME}/bin/pip" install "ansible-lint==${ANSIBLE_LINT_VERSION}"
ln -sf "${ANSIBLE_LINT_HOME}/bin/ansible-lint" /usr/local/bin/ansible-lint
