#!/bin/bash

set -e

# shellcheck disable=SC1091
source dev-container-features-test-lib

check "directory /tmp/hello exists" test -d /tmp/hello

reportResults
