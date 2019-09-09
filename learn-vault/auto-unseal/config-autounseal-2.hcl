disable_mlock = true
ui=true

storage "file" {
  path = "/home/vault/data-2"
}

listener "tcp" {
  address     = "0.0.0.0:8100"
  tls_disable = 1
}

seal "transit" {
  address = "http://127.0.0.1:8200"
  token = ""
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}
