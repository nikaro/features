#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${1:-}" = "DEBUG" ]; then
  set -o xtrace
fi

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/koalaman/shellcheck/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

ARCHITECTURE="$(uname -m)"

curl -sSL "https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/shellcheck-v${VERSION}.linux.${ARCHITECTURE}.tar.xz" -o /tmp/shellcheck.tar.xz
tar -xaf /tmp/shellcheck.tar.xz -C /tmp "shellcheck-v${VERSION}/shellcheck"
mv "/tmp/shellcheck-v${VERSION}/shellcheck" /usr/local/bin/shellcheck
chmod 0755 /usr/local/bin/shellcheck

rm -rf /tmp/shellcheck.tar.xz "/tmp/shellcheck-v${VERSION}"
