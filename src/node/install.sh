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

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/nodejs/node/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

# get architecture
case "$(uname -m)" in
x86_64)
  ARCHITECTURE="x64"
  ;;
aarch64 | armv8* | arm64)
  ARCHITECTURE="arm64"
  ;;
*)
  echo "Architecture unsupported"
  exit 1
  ;;
esac

# set url depending on libc used
if ldd --version | grep -q musl; then
  URL="https://unofficial-builds.nodejs.org/download/release/v${VERSION}/node-v${VERSION}-linux-${ARCHITECTURE}-musl.tar.xz"
  # arm64 is not yet supported for musl
  if [ "${ARCHITECTURE}" = "arm64" ]; then
    echo "arm64-musl unsupported"
    exit 1
  fi
else
  URL="https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-${ARCHITECTURE}.tar.xz"
fi

# install
curl -sSL "${URL}" -o /tmp/node.tar.xz
tar -xaf /tmp/node.tar.xz -C /opt
ln -sf "/opt/node-v${VERSION}-linux-${ARCHITECTURE}/bin/node" /usr/local/bin/node
ln -sf "/opt/node-v${VERSION}-linux-${ARCHITECTURE}/bin/npm" /usr/local/bin/npm
ln -sf "/opt/node-v${VERSION}-linux-${ARCHITECTURE}/bin/npx" /usr/local/bin/npx

# cleanup
rm -rf /tmp/node.tar.xz
