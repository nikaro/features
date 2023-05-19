#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" pyenv --version | grep "2.3.16"
check "ensure is installed" python --version | grep "3.10"

reportResults
