#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" trivy --version | grep "0.42.0"

reportResults
