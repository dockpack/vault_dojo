#!/bin/bash

# Enable ssh secrets engine
vault secrets list|grep ssh || vault secrets enable -path=ssh-client-signer ssh

# Configure Vault with a CA for signing client keys using the /config/ca endpoint.
vault write ssh-client-signer/config/ca generate_signing_key=true

vault read -field=public_key ssh-client-signer/config/ca > ../ansible/files/trusted-user-ca-keys.pem

vault write ssh-client-signer/roles/admin-role -<<"EOH"
{
  "allow_user_certificates": true,
  "allowed_users": "*",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "admin",
  "ttl": "168h0m"
}
EOH

# Ask Vault to sign your public key. This file usually ends in .pub and the contents begin with ssh-rsa ...
# If you are saving the certificate directly beside your SSH keypair, suffix the name with -cert.pub (~/.ssh/id_rsa-cert.pub). With this naming scheme, OpenSSH will automatically use it during authentication
vault write -field=signed_key ssh-client-signer/sign/admin-role \
    public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub

chmod 600 $HOME/.ssh/id_rsa-cert.pu

# View enabled extensions, principals, and metadata of the signed key.
ssh-keygen -Lf ~/.ssh/id_rsa-cert.pub
