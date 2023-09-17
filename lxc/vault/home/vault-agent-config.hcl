vault {
  address = "http://localhost:8200"
}

template {
  destination = "/home/vault/.backblaze-env"
  contents = "
    {{ with secrets \"general/backblaze\" }}
    B2_APPLICATION_KEY_ID={{ .Data.data.token_id }}
    B2_APPLICATION_KEY={{ .Data.data.token }}
    {{ end }}
  "
}
