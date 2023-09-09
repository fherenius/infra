ui            = true
disable_mlock = true # Requires root access to be true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}

storage "file" {
  path = "/home/vault/data"
}
