#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "ensure version" gh version | grep "2.29.0"

reportResults
