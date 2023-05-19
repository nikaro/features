#!/bin/bash

set -e

source dev-container-features-test-lib

check "ensure version" docker --version | grep "23.0.5"

reportResults
