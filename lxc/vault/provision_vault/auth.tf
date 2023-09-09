# Enable the userpass auth
resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# Create fester ures
resource "vault_generic_endpoint" "fester" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/fester"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin"],
  "password": "Changeme"    
}
EOT
}
