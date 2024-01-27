#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -sSL https://dl.k8s.io/release/stable.txt | sed 's/v//')"
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

curl -sSL "https://dl.k8s.io/release/v${VERSION}/bin/linux/${ARCHITECTURE}/kubectl" -o /usr/local/bin/kubectl
chmod 0755 /usr/local/bin/kubectl
