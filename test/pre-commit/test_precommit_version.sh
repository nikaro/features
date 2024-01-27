#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" pre-commit --version | grep "3.3.0"

reportResults
