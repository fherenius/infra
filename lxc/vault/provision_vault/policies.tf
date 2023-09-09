# Create an admin policy
resource "vault_policy" "admin_policy" {
  name   = "admin"
  policy = file("policies/admin-policy.hcl")
}
