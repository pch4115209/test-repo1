#!/bin/bash

set -euo pipefail

echo "Hi there today Monday"
COUNT="${COUNT:-1}"

for ((n=0;n<$COUNT;n++))
do

buildkite-agent pipeline upload <<YAML

steps:
- label: Lookup and build ${RETAILER_ID:-"CK AU Prod"}
  command: sleep $n

YAML
done
