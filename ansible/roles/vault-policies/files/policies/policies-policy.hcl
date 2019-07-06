# Create and manage ACL policies via CLI
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Create and manage ACL policies via API
path "sys/policies/acl" {
  capabilities = ["list"]
}
