#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" pyenv --version | grep "2.3.16"

reportResults
