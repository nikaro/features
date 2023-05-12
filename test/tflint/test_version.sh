#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" tflint --version | grep "0.46.1"

reportResults
