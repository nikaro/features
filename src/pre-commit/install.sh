#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -s https://api.github.com/repos/pre-commit/pre-commit/releases/latest | jq -r '.tag_name' | sed 's/v//')"
fi

curl -sSL "https://github.com/pre-commit/pre-commit/releases/download/v${VERSION}/pre-commit-${VERSION}.pyz" -o /usr/local/bin/pre-commit
chmod 0755 /usr/local/bin/pre-commit
