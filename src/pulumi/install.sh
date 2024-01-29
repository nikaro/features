#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh
reload_profile

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION=$(
    curl -L "https://api.github.com/repos/pulumi/pulumi/releases/latest" |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )
fi

# get architecture
case "$(uname -m)" in
x86_64)
  ARCH="x64"
  ;;
aarch64 | arm64)
  ARCH="arm64"
  ;;
*)
  err "unsupported architecture"
  ;;
esac

# install
FILENAME="pulumi-v${VERSION}-linux-${ARCH}.tar.gz"
URL="https://github.com/pulumi/pulumi/releases/download/v${VERSION}/${FILENAME}"
curl -L "$URL" -o "$FILENAME"
tar -xzf "$FILENAME" -C /usr/local/bin --strip-components=1
rm -f "$FILENAME"
