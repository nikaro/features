#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# get latest version
if [ -z "${VERSION:-}" ]; then
    VERSION="$(curl -s https://api.github.com/repos/mvdan/sh/releases/latest | jq -r '.tag_name' | sed 's/v//')"
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

curl -sSL "https://github.com/mvdan/sh/releases/download/v${VERSION}/shfmt_v${VERSION}_linux_${ARCHITECTURE}" -o /usr/local/bin/shfmt
chmod 0755 /usr/local/bin/shfmt
