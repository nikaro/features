#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" node --version | grep "20.1.0"

reportResults
