#!/bin/bash

set -e

source dev-container-features-test-lib

check "directory /tmp/hello exists" test -d /tmp/hello

reportResults
