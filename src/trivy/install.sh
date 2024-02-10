#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(
    curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )"
fi

case "$(uname -m)" in
x86_64)
  ARCHITECTURE="64bit"
  ;;
aarch64 | armv8* | arm64)
  ARCHITECTURE="ARM64"
  ;;
*)
  echo "Architecture unsupported"
  exit 1
  ;;
esac

curl -sSL "https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-${ARCHITECTURE}.tar.gz" -o /tmp/trivy.tar.gz
tar -xzf /tmp/trivy.tar.gz -C /tmp trivy
mv /tmp/trivy /usr/local/bin/trivy
chmod 0755 /usr/local/bin/trivy

rm -rf /tmp/trivy.tar.gz
