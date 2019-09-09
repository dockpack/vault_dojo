# Enable the transit secrets engine
vault secrets list|grep transit || vault secrets enable transit

# Create a key named 'autounseal'
vault write -f transit/keys/autounseal

# Create autounseal policy
vault policy write autounseal transit.hcl

# Create a new token with autounseal policy.
vault token create -policy="autounseal" 
