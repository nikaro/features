#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name' | sed 's/v//')"
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

curl -sSL "https://get.helm.sh/helm-v${VERSION}-linux-${ARCHITECTURE}.tar.gz" -o /tmp/helm.tar.gz
tar -xzf /tmp/helm.tar.gz -C /tmp "linux-${ARCHITECTURE}/helm"
mv "/tmp/linux-${ARCHITECTURE}/helm" /usr/local/bin/helm
chmod 0755 /usr/local/bin/helm

rm -rf /tmp/helm.tar.gz "/tmp/linux-${ARCHITECTURE}"
