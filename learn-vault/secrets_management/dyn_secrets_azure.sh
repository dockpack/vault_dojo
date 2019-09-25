#!/bin/bash -x

vault secrets list|grep azure || vault secrets enable azure

vault write azure/config \
subscription_id="$ARM_SUBSCRIPTION_ID" \
tenant_id="$ARM_TENANT_ID" \
client_id="$ARM_CLIENT_ID" \
client_secret="$ARM_CLIENT_SECRET"

vault path-help azure
