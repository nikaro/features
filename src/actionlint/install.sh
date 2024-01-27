#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${1:-}" = "DEBUG" ]; then
  set -o xtrace
fi

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
  echo "Architecture unsupported"
  exit 1
  ;;
esac

curl -sSL "https://github.com/rhysd/actionlint/releases/download/v${VERSION}/actionlint_${VERSION}_linux_${ARCHITECTURE}.tar.gz" -o /tmp/actionlint.tar.gz
tar -xzf /tmp/actionlint.tar.gz -C /tmp actionlint
mv /tmp/actionlint /usr/local/bin/actionlint
chmod 0755 /usr/local/bin/actionlint

rm -rf /tmp/actionlint.tar.gz
