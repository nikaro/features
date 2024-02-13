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
  VERSION="$(get_latest_gh_release hashicorp/terraform)"
fi

# install if needed
if ! terraform version | grep -q -e "$VERSION"; then
  FILENAME="terraform_${VERSION}_linux_$(get_arch64_simple).zip"
  URL="https://releases.hashicorp.com/terraform/${VERSION}/${FILENAME}"
  curl -LO "$URL"
  unzip "${FILENAME}" terraform -d /usr/local/bin
  chmod 0755 /usr/local/bin/terraform
  rm -rf "${FILENAME}"
fi
