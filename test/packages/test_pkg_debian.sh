#!/bin/bash

set -e

source dev-container-features-test-lib

check "curl command exists" command -v curl
check "curl --version" curl --version

reportResults
