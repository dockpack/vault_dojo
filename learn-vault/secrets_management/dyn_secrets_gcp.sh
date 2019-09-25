#!/bin/bash -x

vault secrets list|grep gcp || vault secrets enable gcp

vault write gcp/config credentials="@$GOOGLE_APPLICATION_CREDENTIALS"

vault path-help gcp
