#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure is installed" k9s version

reportResults
