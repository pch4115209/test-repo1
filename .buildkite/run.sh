#!/bin/bash

set -euo pipefail

echo "Hi there today Monday"
COUNT="${COUNT:-4}"

RETAILER_IDs=("CK AU" "CS US")

for ((n=1;n<=$COUNT;n++))
do
idx=$((n%2))
retailerName=${RETAILER_IDs[$idx]}

buildkite-agent pipeline upload <<YAML

steps:
  - group: Publish $retailerName
    steps:
      - label: Lookup and build $retailerName
        command:
          - sleep 10  # $((n*1))
          - echo Pulling building env from DDB, e.g. GATSBY_SITE_URL
          - echo Buidling
          - echo Get timestamp - $(date +%s)
          - echo Sync to prebuild bucket under $retailerName/$(date +%s)
          - echo Create a DDB entry
          - ./bin/env.sh
        env:
          GATSBY_SITE_URL: example.com
          GATSBY_XX: XXX

      - label: Deploy $retailerName
        command:
          - sleep 3 # $((n*1))
          - echo Check if there is a latest entry in DDB > $(date +%s)
          - echo if so skip it and exit 0
          - echo if no, sycn it to xxx-www
        concurrency_group: build/concurrency_$retailerName
        concurrency: 1
YAML
done



# curl -H "Authorization: Bearer a1dd84fab76f93951fd337285cc8639f004ffcf1"  "https://api.buildkite.com/v2/organizations/{org.slug}/pipelines/test-repo-1/builds"

# curl -H "Authorization: Bearer a1dd84fab76f93951fd337285cc8639f004ffcf1" -X POST "https://api.buildkite.com/v2/organizations/ppan/pipelines/test-repo-1/builds" \
#   -d '{
#     "commit": "HEAD",
#     "message": "Let's build it"
#     "branch": "master",
#     "env": {
#       "COUNT": "4"
#     }
#   }'


#     GSI         sortKey
# 1.  CKAU#deploy timestamp
# 2.  CKAU#deploy timestamp











