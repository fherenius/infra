# Enable engine for general secrets
resource "vault_mount" "kv-v2" {
  path = "general"
  type = "kv-v2"
}

# Change value to valid token later
resource "vault_kv_secret_v2" "backblaze_token" {
  mount = vault_mount.kv-v2.path
  name  = "backblaze"
  data_json = jsonencode(
    {
      token = "changemetovalidtoken"
    }
  )
}
