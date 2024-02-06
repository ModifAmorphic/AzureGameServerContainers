#! /bin/bash
set -x

## Enables repository name as a valid subject for OIDC
ORGANIZATION="$1"
REPOSITORY="$2"

echo '{ "use_default": false, "include_claim_keys": [ "repo" ] }' | gh api --method PUT repos/${ORGANIZATION}/${REPOSITORY}/actions/oidc/customization/sub --input - --verbose