This Hashicorp Vault unsealing needs one encrypted password file for your team in KBFS:

```
vault_credentials: '/Volumes/Keybase/team/dockpack/vault.json'
```

You can share the passphrase on KBFS, or memorize it by other means.

```
export ANSIBLE_VAULT_PASSWORD_FILE="/Volumes/Keybase ($USER)/team/dockpack/vault.pass"
```

To work with the initial root token in your ENV:
```
export VAULT_TOKEN=$(ansible-vault view "/Volumes/Keybase ($USER)/team/dockpack/vault.json"| jq -r .root_token)
```

Replacing the initial root token after set-up is a best practice.
