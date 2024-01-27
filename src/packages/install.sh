#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable

# exit if no packages are specified
[ -z "${PACKAGES:-}" ] && exit 0

# ensure packages are separated by spaces
PACKAGES=$(printf '%s' "$PACKAGES" | tr ',' ' ')

for package in $PACKAGES; do
  # install packages with distribution package manager
  if command -v apk >/dev/null 2>&1; then
    apk add --no-cache "$package"
  elif command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y "$package"
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y "$package"
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Syu "$package"
  elif command -v yum >/dev/null 2>&1; then
    yum install -y "$package"
  elif command -v zypper >/dev/null 2>&1; then
    zypper install -y "$package"
  else
    echo "Unsupported package manager, package installation skipped"
    exit 1
  fi
done
