#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh
reload_profile

# install requirements
pkg_install curl

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION="$(curl -sSL 'https://go.dev/VERSION?m=text' | head -n 1)"
fi

# get architecture
case "$(uname -m)" in
x86_64)
  ARCH="amd64"
  ;;
aarch64 | armv8* | arm64)
  ARCH="arm64"
  ;;
*)
  err "unsupported architecture"
  ;;
esac

# install if needed
if ! go version | grep -q -e "$VERSION"; then
  curl -sSL "https://go.dev/dl/${VERSION}.linux-${ARCH}.tar.gz" -o /tmp/go.tar.gz
  tar -xaf /tmp/go.tar.gz -C /usr/local
  rm -f /tmp/go.tar.gz

  # setup shells
  if [ -d "/etc/profile.d" ]; then
    {
      echo "export FEATURE_GOPATH=/usr/local/go"
      echo "export PATH=\$FEATURE_GOPATH/bin:$PATH"
    } >/etc/profile.d/go.sh
  fi
  if [ -d "/etc/fish/conf.d" ]; then
    {
      echo "set -x FEATURE_GOPATH /usr/local/go"
      # shellcheck disable=SC2016
      echo 'set -p fish_user_paths $FEATURE_GOPATH/bin'
    } >/etc/fish/conf.d/go.fish
  fi
fi

# remove installed requirements
pkg_remove curl
