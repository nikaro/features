#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" pre-commit --version | grep "3.3.0"

reportResults
