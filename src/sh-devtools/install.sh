#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# install shfmt
if [ -z "${SHFMT_VERSION:-}" ]; then
  SHFMT_VERSION=$(
    curl -L "https://api.github.com/repos/mvdan/sh/releases/latest" |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )
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
curl -sSL \
  "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_${ARCHITECTURE}" \
  -o /usr/local/bin/shfmt
chmod 0755 /usr/local/bin/shfmt

# install shellcheck
if [ -z "${SHELLCHECK_VERSION:-}" ]; then
  SHELLCHECK_VERSION=$(
    curl -L "https://api.github.com/repos/koalaman/shellcheck/releases/latest" |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )
fi
curl -sSL \
  "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.$(uname -m).tar.xz" \
  -o /tmp/shellcheck.tar.xz
tar -xaf /tmp/shellcheck.tar.xz -C /tmp "shellcheck-v${SHELLCHECK_VERSION}/shellcheck"
mv "/tmp/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/shellcheck
chmod 0755 /usr/local/bin/shellcheck
rm -rf /tmp/shellcheck.tar.xz "/tmp/shellcheck-v${SHELLCHECK_VERSION}"
