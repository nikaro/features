#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" terraform -version | grep "1.4.5"

reportResults
