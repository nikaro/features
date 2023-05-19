#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" tfsec --version | grep "1.28.1"

reportResults
