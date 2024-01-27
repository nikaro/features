#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" shellcheck --version | grep "0.9.0"

reportResults
