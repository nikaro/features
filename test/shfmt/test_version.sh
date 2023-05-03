#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" shfmt --version | grep "3.5.1"

reportResults
