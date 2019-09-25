#!/bin/bash -x

echo "Enable the database secret engine"
vault secrets list|grep database || vault secrets enable database

echo "let's run PostgreSQL Docker image in a container."
docker ps|grep postgres || docker run --name postgres -e POSTGRES_USER=root -e POSTGRES_PASSWORD="$PG_PASS" -d -p 5432:5432 postgres:latest

echo "Configure PostgreSQL secret engine"
vault write database/config/postgresql plugin_name=postgresql-database-plugin allowed_roles=readonly \
        connection_url="postgresql://root:$PG_PASS@10.0.2.2:5432/postgres?sslmode=disable"

echo "Create an HTTP request payload"
tee payload.json <<EOF
{
    "plugin_name": "postgresql-database-plugin",
    "allowed_roles": "readonly",
    "connection_url": "postgresql://root:$PG_PASS@10.0.2.2:5432/postgres?sslmode=disable"
}
EOF

echo "Invoke the database/config/postgresql endpoint"
curl --header "X-Vault-Token: $VAULT_DEV_ROOT_TOKEN_ID" --request POST --data @payload.json \
       "$VAULT_ADDR/v1/database/config/postgresql"

echo "Create a role named readonly with default TTL of 1 hour, and max TTL of the credential is set to 24 hours. "
# The readonly.sql statement is passed as the role creation statement.
vault write database/roles/readonly db_name=postgresql \
        creation_statements=@readonly.sql \
        default_ttl=1h max_ttl=24h

echo 'Create "apps" policy'
vault policy write apps apps-policy.hcl

echo 'Create a new token with app policy'
MY_TOKEN=$(vault token create -policy="apps" -format=json -field=token|jq -r)

echo 'Get database access'
VAULT_TOKEN=$MY_TOKEN vault read database/creds/readonly
