#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" actionlint -version | grep "1.6.24"

reportResults
