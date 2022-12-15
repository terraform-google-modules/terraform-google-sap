

terraform {
  backend "gcs" {
    bucket = "core-connect-dev-terraform-state"
  }

}
