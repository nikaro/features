#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" sops --version | grep "3.7.2"

reportResults
