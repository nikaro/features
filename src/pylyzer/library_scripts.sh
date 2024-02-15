#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

err() {
  echo >&2 "$1"
  exit 1
}

git_checkout() {
  repo="$1"
  dir="$2"
  branch="$3"
  [ -d "$dir" ] || git -c advice.detachedHead=0 clone --branch "$branch" --depth 1 "$repo" "$dir" || err "Failed to clone $repo"
}

reload_profile() {
  set +o errexit
  . /etc/profile
  set -o errexit
}

pkg_install() {
  # ensure package is installed
  pkg="$1"
  if [ -x "/usr/bin/apt-get" ]; then
    if ! dpkg -l | grep '^ii' | awk '{print $2}' | grep -q -e "^$pkg\$"; then
      apt-get update -y
      apt-get -y install "$pkg"
      # create a semaphor file
      mktemp -t "$pkg-XXXXXXXXXX"
    fi
  elif [ -x "/sbin/apk" ]; then
    if ! apk info 2>&1 | grep -q -e "^$pkg\$"; then
      apk add --no-cache "$pkg"
      # create a semaphor file
      mktemp -t "$pkg-XXXXXXXXXX"
    fi
  else
    err "unsupported distro"
  fi
}

ensure_nanolayer() {
  # ensure nanolayer is installed
  if ! type nanolayer >/dev/null 2>&1; then
    tmp_dir=$(mktemp -d -t nanolayer-XXXXXXXXXX)
    filename=nanolayer-"$(uname -m)"-unknown-linux-$(get_libc).tgz
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
  pkg="$1"
  tmp_dir=$(dirname "$(mktemp -t detect-tmp-dir-XXXXXXXXXX)")
  if ls "$tmp_dir"/"$pkg"-* >/dev/null 2>&1; then
    if [ -x "/usr/bin/apt-get" ]; then
      apt-get -y purge "$pkg" --auto-remove
      rm -rf /var/lib/apt/lists/*
    elif [ -x "/sbin/apk" ]; then
      apk del "$pkg"
    else
      err "unsupported distro"
    fi
    rm -f "$tmp_dir"/"$pkg"-*
  fi
}

remove_nanolayer() {
  # remove nanolayer if it was installed by this script
  tmp_dir=$(dirname "$(mktemp -t detect-tmp-dir-XXXXXXXXXX)")
  if ls "$tmp_dir"/nanolayer-* >/dev/null 2>&1; then
    if type nanolayer >/dev/null 2>&1; then
      rm -f /usr/local/bin/nanolayer
    fi
    rm -f "$tmp_dir"/nanolayer-*
  fi
}

get_arch64_simple() {
  case "$(uname -m)" in
  x86_64)
    echo "amd64"
    ;;
  aarch64 | armv8* | arm64)
    echo "arm64"
    ;;
  *)
    err "unsupported architecture: $(uname -m)"
    ;;
  esac
}

get_arch64_x() {
  case "$(uname -m)" in
  x86_64)
    echo "x64"
    ;;
  aarch64 | armv8* | arm64)
    echo "arm64"
    ;;
  *)
    err "unsupported architecture: $(uname -m)"
    ;;
  esac
}

get_arch64_b() {
  case "$(uname -m)" in
  x86_64)
    echo "64bit"
    ;;
  aarch64 | armv8* | arm64)
    echo "ARM64"
    ;;
  *)
    err "unsupported architecture: $(uname -m)"
    ;;
  esac
}

get_latest_gh_release() {
  repo="$1"
  curl -s "https://api.github.com/repos/${repo}/releases/latest" |
    grep tag_name |
    cut -d '"' -f 4 |
    sed 's/v//'
}

get_libc() {
  if ldd --version | grep -q musl; then
    echo "musl"
  else
    echo "gnu"
  fi
}
