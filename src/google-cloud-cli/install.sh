#!/usr/bin/env sh

set -o errexit # Exit on error
set -o nounset # Exit on uninitialized variable
if [ "${1:-}" = "DEBUG" ]; then
  set -o xtrace
fi

# get latest version
if [ -z "${VERSION:-}" ]; then
  VERSION=$(curl -sSL https://packages.cloud.google.com/apt/dists/cloud-sdk/main/binary-arm64/Packages | grep -A 2 '^Package: google-cloud-sdk$' | tail -n 1 | awk '/Version/ {print $2}' | sed 's/-[0-9]*$//')
fi

case "$(uname -m)" in
x86_64)
  ARCHITECTURE="x86_64"
  ;;
aarch64 | armv8* | arm64)
  ARCHITECTURE="arm"
  ;;
*)
  echo "Architecture unsupported"
  exit 1
  ;;
esac

curl -sSL "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${VERSION}-linux-${ARCHITECTURE}.tar.gz" -o /tmp/gcloud.tar.gz
tar -xzf /tmp/gcloud.tar.gz -C /tmp
mv /tmp/google-cloud-sdk /opt/

INSTALL_ARGS="--quiet"
[ -n "${USAGE_REPORTING:-}" ] && INSTALL_ARGS="${INSTALL_ARGS} --usage-reporting ${USAGE_REPORTING:-}"
[ -n "${RC_PATH:-}" ] && INSTALL_ARGS="${INSTALL_ARGS} --rc-path ${RC_PATH:-}"
[ -n "${OVERRIDE_COMPONENTS:-}" ] && INSTALL_ARGS="${INSTALL_ARGS} --overide-components ${OVERRIDE_COMPONENTS:-}"
[ -n "${ADDITIONAL_COMPONENTS:-}" ] && INSTALL_ARGS="${INSTALL_ARGS} --additional-components ${ADDITIONAL_COMPONENTS:-}"

# shellcheck disable=SC2086
/opt/google-cloud-sdk/install.sh $INSTALL_ARGS
