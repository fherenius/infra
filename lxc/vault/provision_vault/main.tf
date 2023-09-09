terraform {
  required_providers {
    vault = "> 3.7.0"
  }
}

provider "vault" {
  address = "http://192.168.1.210:8200"
}
