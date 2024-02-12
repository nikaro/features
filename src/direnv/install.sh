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
  VERSION="$(get_latest_gh_release direnv/direnv)"
fi

# install if needed
if ! direnv version | grep -q -e "$VERSION"; then
  FILENAME="direnv.linux-$(get_arch64_simple)"
  URL="https://github.com/direnv/direnv/releases/download/v${VERSION}/${FILENAME}"
  curl -L "$URL" -o /usr/local/bin/direnv
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
