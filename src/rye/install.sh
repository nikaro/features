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
  VERSION=$(
    curl -L "https://api.github.com/repos/mitsuhiko/rye/releases/latest" |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )
fi

# install
FILENAME="rye-$(uname -m)-linux"
URL="https://github.com/mitsuhiko/rye/releases/download/${VERSION}/${FILENAME}.gz"
curl -L "$URL" -o "/usr/local/bin/${FILENAME}.gz"
gunzip "/usr/local/bin/${FILENAME}.gz"
mv -v "/usr/local/bin/${FILENAME}" /usr/local/bin/rye
chmod +x /usr/local/bin/rye

# setup shells
if [ -d "/etc/profile.d" ]; then
  {
    echo "export RYE_NO_AUTO_INSTALL=1"
  } >>/etc/profile.d/rye.sh
fi
if [ -d "/etc/fish/conf.d" ]; then
  {
    echo "set -x RYE_NO_AUTO_INSTALL 1"
  } >/etc/fish/conf.d/rye.fish
fi
