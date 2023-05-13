#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r '.tag_name' | sed 's/v//')"
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

curl -sSL "https://github.com/derailed/k9s/releases/download/v${VERSION}/k9s_Linux_${ARCHITECTURE}.tar.gz" -o /tmp/k9s.tar.gz
tar -xzf /tmp/k9s.tar.gz -C /tmp k9s
mv /tmp/k9s /usr/local/bin/k9s
chmod 0755 /usr/local/bin/k9s

rm -rf /tmp/k9s.tar.gz
