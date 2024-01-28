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

# set options
VERSION="${VERSION:-3.12}"

if ! python3 --version 2>&1 | grep -q -e "^Python $VERSION"; then
  # detect if the distribution is on glibc or musl
  if ldd --version | grep -q musl; then
    LIBC="musl"
  else
    LIBC="gnu"
  fi

  # get download url
  JQ_FILTER='.assets[] | select('
  JQ_FILTER=$JQ_FILTER' (.name | contains("linux"))'
  JQ_FILTER=$JQ_FILTER' and (.name | contains("'$VERSION'"))'
  JQ_FILTER=$JQ_FILTER' and (.name | contains("'$LIBC'"))'
  JQ_FILTER=$JQ_FILTER' and (.name | contains("-'$(uname -m)'-"))'
  JQ_FILTER=$JQ_FILTER' and (.name | endswith(".tar.gz"))'
  JQ_FILTER=$JQ_FILTER' ) | .browser_download_url'
  URL="$(curl -s https://api.github.com/repos/indygreg/python-build-standalone/releases/latest | jq -r "$JQ_FILTER")"

  # install
  curl -sSL "$URL" -o /tmp/python.tar.gz
  tar -xaf /tmp/python.tar.gz -C /usr/local --strip-components 1
  rm -f /tmp/python.tar.gz
fi

# remove installed requirements
pkg_remove curl
pkg_remove jq
