#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" terraform -version | grep "1.4.5"

reportResults
