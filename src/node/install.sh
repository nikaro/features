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

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -fsSL https://api.github.com/repos/nodejs/node/releases/latest | jq -r '.tag_name')"
fi

# get architecture
case "$(uname -m)" in
x86_64)
  ARCH="x64"
  ;;
aarch64 | armv8* | arm64)
  ARCH="arm64"
  ;;
*)
  err "unsupported architecture"
  ;;
esac

# install if needed
if ! node --version 2>&1 | grep -q -e "^${VERSION}"; then
  # set url
  if ldd --version | grep -q musl; then
    URL="https://unofficial-builds.nodejs.org/download/release/${VERSION}/node-${VERSION}-linux-${ARCH}-musl.tar.xz"
    # arm64 is not yet supported for musl
    if [ "${ARCH}" = "arm64" ]; then
      err "arm64-musl unsupported"
    fi
  else
    URL="https://nodejs.org/dist/${VERSION}/node-${VERSION}-linux-${ARCH}.tar.xz"
  fi

  # download and install
  curl -fsSL "${URL}" -o /tmp/node.tar.xz
  tar -xaf /tmp/node.tar.xz -C /opt
  rm -rf /tmp/node.tar.xz

  # setup shells
  if [ -d "/etc/profile.d" ]; then
    {
      echo "export PATH=\"/opt/node-${VERSION}-linux-${ARCH}/bin:\$PATH\""
    } >/etc/profile.d/node.sh
  fi
  if [ -d "/etc/fish/conf.d" ]; then
    {
      echo "set -p fish_user_paths /opt/node-${VERSION}-linux-${ARCH}/bin"
    } >/etc/fish/conf.d/node.fish
  fi
fi

# remove installed requirements
pkg_remove curl
pkg_remove jq
