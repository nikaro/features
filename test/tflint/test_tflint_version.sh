#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" tflint --version | grep "0.46.0"

reportResults
