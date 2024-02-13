#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(get_latest_gh_release nodejs/node)"
fi

# install if needed
if ! node --version 2>&1 | grep -q -e "^v${VERSION}$"; then
  # get architecture
  ARCH="$(get_arch64_x)"

  # set url
  if ldd --version | grep -q musl; then
    FILENAME=node-v${VERSION}-linux-${ARCH}-musl.tar.xz
    URL="https://unofficial-builds.nodejs.org/download/release/v${VERSION}/${FILENAME}"
    # arm64 is not yet supported for musl
    if [ "${ARCH}" = "arm64" ]; then
      err "arm64-musl unsupported"
    fi
  else
    FILENAME=node-v${VERSION}-linux-${ARCH}.tar.xz
    URL="https://nodejs.org/dist/v${VERSION}/${FILENAME}"
  fi

  # download and install
  curl -L "$URL" -o "/tmp/${FILENAME}"
  tar \
    --extract \
    --verbose \
    --auto-compress \
    --file="/tmp/${FILENAME}" \
    --exclude="CHANGELOG.md" \
    --exclude="LICENSE" \
    --exclude="README.md" \
    --strip-components=1 \
    --directory=/usr/local
  rm -rf "/tmp/${FILENAME}"
fi
