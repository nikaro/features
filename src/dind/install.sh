#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

# install requirements
pkg_install curl
pkg_install jq

# get architecture
ARCHITECTURE="$(uname -m)"
# get architecture for buildx
case "${ARCHITECTURE}" in
x86_64)
  BUILDX_ARCHITECTURE="amd64"
  ;;
aarch64 | armv8* | arm64)
  BUILDX_ARCHITECTURE="arm64"
  ;;
*)
  echo "Architecture unsupported"
  exit 1
  ;;
esac

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/moby/moby/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi
# get latest buildx version
if [ -z "${BUILDX_VERSION:-}" ]; then
  BUILDX_VERSION="$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi
# get latest compose version
if [ -z "${COMPOSE_VERSION:-}" ]; then
  COMPOSE_VERSION="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

# install
URL="https://download.docker.com/linux/static/stable/${ARCHITECTURE}"
curl -sSL "${URL}/docker-${VERSION}.tgz" -o /tmp/docker.tgz
tar -xaf /tmp/docker.tgz -C /usr/local/bin/ --strip-components=1
# install buildx
mkdir -p /usr/local/libexec/docker/cli-plugins
curl -sSL "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-${BUILDX_ARCHITECTURE}" -o /usr/local/libexec/docker/cli-plugins/docker-buildx
chmod +x /usr/local/libexec/docker/cli-plugins/docker-buildx
# install compose
mkdir -p /usr/local/libexec/docker/cli-plugins
curl -sSL "https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-${ARCHITECTURE}" -o /usr/local/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/local/libexec/docker/cli-plugins/docker-compose

# configure docker group
groupadd docker
if [ -n "${USERNAME:-}" ] && grep -q "${USERNAME:-}" /etc/passwd; then
  usermod -aG docker "${USERNAME:-}"
fi

# copy entrypoint script
DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
cp "${DIR}/entrypoint.sh" /dockerd-entrypoint.sh

# cleanup
rm -rf /tmp/docker.tgz

# remove installed requirements
pkg_remove curl
pkg_remove jq
