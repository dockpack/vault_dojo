
# Manage secret engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/mounts"
{
  capabilities = ["read", "list"]
}

# List, create, update, and delete key/value secrets
path "secrets/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}


path "pki/*"
{
  capabilities = ["create", "read", "update", "list"]
}
path "aws/*"
{
  capabilities = ["create", "read", "update", "list"]
}
