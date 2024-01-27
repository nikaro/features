#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" kubectl version --client | grep "1.27.0"

reportResults
