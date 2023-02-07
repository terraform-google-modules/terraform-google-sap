terraform {
  backend "gcs" {
    bucket = "core-connect-dev-terraform-state"
    prefix = "s4_test"
  }

}
