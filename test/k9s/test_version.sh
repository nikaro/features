#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" k9s version | grep "0.27.2"

reportResults
