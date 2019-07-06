#!/bin/bash -x

vault secrets list|grep gcp || vault secrets enable gcp

vault write gcp/config credentials="@$GOOGLE_APPLICATION_CREDENTIALS"

vault write gcp/roleset/my-token-roleset \
project=$GCP_PROJECT \
secret_type="access_token"  \
token_scopes="https://www.googleapis.com/auth/cloud-platform" \
bindings=-<<EOF
  resource "//cloudresourcemanager.googleapis.com/projects/$GCP_PROJECT_ID" {
    roles = ["roles/viewer"]
  }
EOF

vault path-help gcp
