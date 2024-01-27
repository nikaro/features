#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "curl command exists" command -v curl
check "curl --version" curl --version

reportResults
