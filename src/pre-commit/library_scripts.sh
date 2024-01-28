#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

err() {
  echo >&2 "$1"
  exit 1
}

git_checkout() {
  [ -d "$2" ] || git -c advice.detachedHead=0 clone --branch "$3" --depth 1 "$1" "$2" || err "Failed to clone $1"
}

reload_profile() {
  set +o errexit
  . /etc/profile
  set -o errexit
}

pkg_install() {
  # ensure package is installed
  if [ -x "/usr/bin/apt-get" ]; then
    if ! dpkg -l | grep '^ii' | awk '{print $2}' | grep -q -e "^$1\$"; then
      apt-get update -y
      apt-get -y install "$1"
      # create a semaphor file
      mktemp -t "$1-XXXXXXXXXX"
    fi
  elif [ -x "/sbin/apk" ]; then
    if ! apk info 2>&1 | grep -q -e "^$1\$"; then
      apk add --no-cache "$1"
      # create a semaphor file
      mktemp -t "$1-XXXXXXXXXX"
    fi
  else
    err "unsupported distro"
  fi
}

ensure_nanolayer() {
  # ensure nanolayer is installed
  pkg_install curl
  pkg_install jq

  if ! type nanolayer >/dev/null 2>&1; then
    if [ -x "/sbin/apk" ]; then
      clib_type=musl
    else
      clib_type=gnu
    fi

    tmp_dir=$(mktemp -d -t nanolayer-XXXXXXXXXX)
    filename=nanolayer-"$(uname -m)"-unknown-linux-$clib_type.tgz
    repo="devcontainers-contrib/nanolayer"
    version=$(curl -s https://api.github.com/repos/$repo/releases/latest | jq -r '.tag_name')

    curl -sfL "https://github.com/$repo/releases/download/$version/$filename" -o "$tmp_dir/$filename"
    tar xfzv "$tmp_dir/$filename" -C "/usr/local/bin"
    chmod a+x "/usr/local/bin/nanolayer"
    rm -rf "$tmp_dir"

    # create a semaphor file
    mktemp -t nanolayer-XXXXXXXXXX
  fi
}

pkg_remove() {
  # remove package if it was installed by this script
  tmp_dir=$(dirname "$(mktemp -t detect-tmp-dir-XXXXXXXXXX)")
  if ls "$tmp_dir"/"$1"-* >/dev/null 2>&1; then
    if [ -x "/usr/bin/apt-get" ]; then
      apt-get -y purge "$1" --auto-remove
      rm -rf /var/lib/apt/lists/*
    elif [ -x "/sbin/apk" ]; then
      apk del "$1"
    else
      err "unsupported distro"
    fi
    rm -f "$tmp_dir"/"$1"-*
  fi
}

remove_nanolayer() {
  # remove nanolayer if it was installed by this script
  tmp_dir=$(dirname "$(mktemp -t detect-tmp-dir-XXXXXXXXXX)")
  if ls "$tmp_dir"/nanolayer-* >/dev/null 2>&1; then
    if type nanolayer >/dev/null 2>&1; then
      rm -f /usr/local/bin/nanolayer
    fi
    pkg_remove curl
    pkg_remove jq
    rm -f "$tmp_dir"/nanolayer-*
  fi
}
