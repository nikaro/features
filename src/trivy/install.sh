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
  VERSION="$(get_latest_gh_release aquasecurity/trivy)"
fi

if ! trivy version | grep -q -e "$VERSION$"; then
  FILENAME="trivy_${VERSION}_Linux-$(get_arch64_b).tar.gz"
  URL="https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/${FILENAME}"
  curl -L "$URL" -o "/tmp/${FILENAME}"
  tar \
    --extract \
    --verbose \
    --auto-compress \
    --file="/tmp/${FILENAME}" \
    --directory=/usr/local/bin \
    trivy
  chmod 0755 /usr/local/bin/trivy
  rm -rf "/tmp/${FILENAME}"
fi
