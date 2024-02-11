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
  VERSION="$(get_latest_gh_release opentofu/opentofu)"
fi

# install if needed
if ! tofu version | grep -q -e "$VERSION"; then
  FILENAME="tofu_${VERSION}_linux_$(get_arch64_simple).zip"
  URL="https://github.com/opentofu/opentofu/releases/download/v${VERSION}/${FILENAME}"
  curl -LO "$URL"
  unzip "${FILENAME}" tofu -d /usr/local/bin
  chmod 0755 /usr/local/bin/tofu
  rm -rf "${FILENAME}"
fi
