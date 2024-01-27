#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ -n "${DEBUG:-}" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh

pkg_install curl
pkg_install jq

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/rhysd/actionlint/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

case "$(uname -m)" in
x86_64)
  ARCHITECTURE="amd64"
  ;;
aarch64 | armv8* | arm64)
  ARCHITECTURE="arm64"
  ;;
*)
  err "Architecture unsupported"
  ;;
esac

curl -sSL "https://github.com/rhysd/actionlint/releases/download/v${VERSION}/actionlint_${VERSION}_linux_${ARCHITECTURE}.tar.gz" -o /tmp/actionlint.tar.gz
tar -xzf /tmp/actionlint.tar.gz -C /tmp actionlint
mv /tmp/actionlint /usr/local/bin/actionlint
chmod 0755 /usr/local/bin/actionlint

rm -rf /tmp/actionlint.tar.gz

pkg_remove curl
pkg_remove jq
