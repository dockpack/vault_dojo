#!/bin/bash

# Enable the PKI secrets engine
vault secrets list|grep pki || vault secrets enable pki

vault secrets tune -max-lease-ttl=8760h pki

# Configure a CA certificate and private key.
vault write pki/root/generate/internal \
    common_name=server.dc1.consul \
    ttl=8760h

# Update the CRL location and issuing certificates. These values can be updated in the future.
vault write pki/config/urls \
    issuing_certificates="http://server.dc1.consul:8200/v1/pki/ca" \
    crl_distribution_points="http://server.dc1.consul:8200/v1/pki/crl"

# The next step is to configure a role. A role is a logical name that maps to a policy used to generate those credentials. 
vault write pki/roles/dot-test \
    allowed_domains=test \
    allow_subdomains=true max_ttl=72h

# To generate a new certificate, we simply write to the issue endpoint with that role name
vault write pki/issue/dot-test common_name=webserver.test 
