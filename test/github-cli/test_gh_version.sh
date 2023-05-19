#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" gh version | grep "2.29.0"

reportResults
