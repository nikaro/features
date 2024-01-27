#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${1:-}" = "DEBUG" ]; then
  set -o xtrace
fi

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | sed 's/v//')"
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

curl -sSL "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_${ARCHITECTURE}.zip" -o /tmp/terraform.zip
unzip /tmp/terraform.zip terraform -d /tmp/
mv /tmp/terraform /usr/local/bin/terraform
chmod 0755 /usr/local/bin/terraform

rm -rf /tmp/terraform.zip
