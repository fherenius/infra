vault {
  address = "http://localhost:8200"
}

auto_auth {
  method = {
    type = "token_file"
    config = {
      token_file_path = "/home/vault/.vault-token"
    }
  }
}

template {
  destination = "/home/vault/.backblaze-env"
  contents    = <<EOF
    {{ with secret "general/backblaze" }}
    B2_APPLICATION_KEY_ID={{ .Data.data.token_id }}
    B2_APPLICATION_KEY={{ .Data.data.token }}
    {{ end }}
  EOF
}
