#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" tfsec --version | grep "1.28.1"

reportResults
