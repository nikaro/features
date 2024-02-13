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
  VERSION="$(get_latest_gh_release terraform-linters/tflint)"
fi

# install if needed
if ! tflint --version | grep -q "$VERSION"; then
  FILENAME="tflint_linux_$(get_arch64_simple).zip"
  URL="https://github.com/terraform-linters/tflint/releases/download/v${VERSION}/${FILENAME}"
  curl -LO "$URL"
  unzip "${FILENAME}" tflint -d /usr/local/bin
  chmod 0755 /usr/local/bin/tflint
  rm -rf "${FILENAME}"
fi
