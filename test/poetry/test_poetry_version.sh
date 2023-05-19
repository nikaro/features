#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" poetry --version | grep "1.4.1"

reportResults
