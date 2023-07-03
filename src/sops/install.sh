#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# get latest version
if [ -z "${VERSION:-}" ]; then
    VERSION="$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq -r '.tag_name' | sed 's/v//')"
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

curl -sSL "https://github.com/getsops/sops/releases/download/v${VERSION}/sops-v${VERSION}.linux.${ARCHITECTURE}" -o /usr/local/bin/sops
chmod 0755 /usr/local/bin/sops
