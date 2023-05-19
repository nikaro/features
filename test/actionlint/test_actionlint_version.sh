#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" actionlint -version | grep "1.6.24"

reportResults
