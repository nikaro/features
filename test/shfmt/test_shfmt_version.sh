#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" shfmt --version | grep "3.5.1"

reportResults
