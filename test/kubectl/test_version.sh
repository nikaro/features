#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" kubectl version --client | grep "1.27.0"

reportResults
