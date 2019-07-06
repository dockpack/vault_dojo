# Create admin policy
vault policy write admin admin-policy.hcl

# Create policies policy
vault policy write policies policies-policy.hcl

# Create secret policy
vault policy write secret secret-policy.hcl

# Create engines policy
vault policy write engines engines-policy.hcl
