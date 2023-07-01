#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# get latest version
if [ -z "${VERSION:-}" ]; then
    VERSION="$(curl -s https://api.github.com/repos/hadolint/hadolint/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

case "$(uname -m)" in
x86_64)
    ARCHITECTURE="x84_64"
    ;;
aarch64 | armv8* | arm64)
    ARCHITECTURE="arm64"
    ;;
*)
    echo "Architecture unsupported"
    exit 1
    ;;
esac

curl -sSL "https://github.com/hadolint/hadolint/releases/download/v${VERSION}/hadolint-Linux-${ARCHITECTURE}" -o /usr/local/bin/hadolint
chmod 0755 /usr/local/bin/hadolint
