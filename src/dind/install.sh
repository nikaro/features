#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${1:-}" = "DEBUG" ]; then
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

# get architecture
ARCHITECTURE="$(uname -m)"

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/moby/moby/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

# install
URL="https://download.docker.com/linux/static/stable/${ARCHITECTURE}"
curl -sSL "${URL}/docker-${VERSION}.tgz" -o /tmp/docker.tgz
tar -xaf /tmp/docker.tgz -C /usr/local/bin/ --strip-components=1

# configure docker group
groupadd docker
if [ -z "${USERNAME:-}" ]; then
  usermod -aG docker "${USERNAME}"
fi

# copy entrypoint script
DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
cp "${DIR}/entrypoint.sh" /dockerd-entrypoint.sh

# cleanup
rm -rf /tmp/docker.tgz
