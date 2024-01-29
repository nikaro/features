#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${DEBUG:-}" = "true" ]; then
  set -o xtrace
fi

# shellcheck source=library_scripts.sh
. ./library_scripts.sh
reload_profile

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION=$(
    curl -L "https://api.github.com/repos/direnv/direnv/releases/latest" |
      grep tag_name |
      cut -d '"' -f 4 |
      sed 's/v//'
  )
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
if ! direnv version | grep -q -e "$VERSION"; then
  curl -L "https://github.com/direnv/direnv/releases/download/v${VERSION}/direnv.linux-${ARCH}" \
    -o /usr/local/bin/direnv
  chmod +x /usr/local/bin/direnv

  # setup shells
  if [ -d "/etc/bash.bashrc" ]; then
    {
      # shellcheck disable=SC2016
      echo 'eval "$(direnv hook bash)"'
    } >>/etc/bash.bashrc
  fi
  if [ -d "/etc/zsh/zshrc" ]; then
    {
      # shellcheck disable=SC2016
      echo 'eval "$(direnv hook zsh)"'
    } >>/etc/zsh/zshrc
  fi
  if [ -d "/etc/fish/conf.d" ]; then
    {
      echo "direnv hook fish | source"
    } >/etc/fish/conf.d/direnv.fish
  fi
fi
