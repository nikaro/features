#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" shellcheck --version | grep "0.9.0"

reportResults
