This crypto needs one encrypted password file for your team in KBFS:
```
export ANSIBLE_VAULT_PASSWORD_FILE="/Volumes/Keybase ($USER)/team/dockpack/vault.pass"
```

To work with the root token in your ENV
```
export VAULT_TOKEN=$(ansible-vault view "/Volumes/Keybase ($USER)/team/dockpack/vault.json"| jq -r .root_token)
```
