api_addr = "https://vault.internal.api.gltile.dev"
plugin_directory = "/home/gltile/plugins"
default_max_request_duration = "90s"
disable_clustering = true
disable_mlock = true
ui = true

storage "gcs" {
  bucket = "gltile-vault"
}

seal "gcpckms" {
  project = "gltile"
  region = "us-central1"
  key_ring = "vault-server"
  crypto_key = "vault"
}

listener "tcp" {
  address = "0.0.0.0:8000"
  tls_disable = 1
}