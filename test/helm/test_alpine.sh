#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure is installed" helm version

reportResults
