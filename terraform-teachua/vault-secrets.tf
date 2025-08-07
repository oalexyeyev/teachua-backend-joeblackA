resource "vault_kv_secret_v2" "db_password" {
  mount = "secret"
  name  = "teachua/db_password"

  data_json = jsonencode({
    password = random_password.db_password.result
  })
  depends_on = [random_password.db_password]
}

