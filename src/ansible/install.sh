#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# install requirements
if [ -n "${REQUIREMENTS:-}" ]; then
  # ensure packages are separated by spaces
  REQUIREMENTS=$(printf '%s' "$REQUIREMENTS" | tr ',' ' ')
  for package in $REQUIREMENTS; do
    # determine distribution package manager
    if command -v apk >/dev/null 2>&1; then
      apk add --no-cache "$package"
    elif command -v apt-get >/dev/null 2>&1; then
      apt-get update
      apt-get install -y "$package"
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y "$package"
    elif command -v pacman >/dev/null 2>&1; then
      pacman -Syu "$package"
    elif command -v yum >/dev/null 2>&1; then
      yum install -y "$package"
    elif command -v zypper >/dev/null 2>&1; then
      zypper install -y "$package"
    else
      echo "Unsupported package manager, requirements installation failed"
      exit 1
    fi
  done
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

# postCreateCommand script path
POST_CREATE_COMMAND_SCRIPT_PATH="/usr/local/share/feature-ansible-post-create.sh"

tee "$POST_CREATE_COMMAND_SCRIPT_PATH" >/dev/null \
  <<EOF
#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

VENV_PATH=${VENV_PATH}
DEPENDENCIES=${DEPENDENCIES}
EOF

tee -a "$POST_CREATE_COMMAND_SCRIPT_PATH" >/dev/null \
  <<'EOF'

# install dependencies
if [ -n "${DEPENDENCIES:-}" ]; then
  # ensure packages are separated by spaces
  DEPENDENCIES=$(printf '%s' "$DEPENDENCIES" | tr ',' ' ')
  for package in $DEPENDENCIES; do
    sudo "${VENV_PATH}/bin/pip" install "$package"
  done
fi

# link ansible binaries into PATH
for bin in "${VENV_PATH}"/bin/ansible*; do
  sudo ln -sf "${bin}" /usr/local/bin/
done
EOF

chmod 755 "$POST_CREATE_COMMAND_SCRIPT_PATH"
