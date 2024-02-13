#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# install if needed
if ! command -v aws >/dev/null 2>&1; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip"
  unzip -d /tmp awscliv2.zip
  /tmp/aws/install --bin-dir "$BIN_DIR" --install-dir "$INSTALL_DIR"
  rm -rf /tmp/aws
fi
