#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure is installed" pyenv --version
check "ensure is installed" python --version

reportResults
