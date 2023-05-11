#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" helm version | grep "3.12.0"

reportResults
