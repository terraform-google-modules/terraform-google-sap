

data "google_storage_bucket" "media" {
  name     = var.media_bucket_name
  provider = google-beta
}

resource "google_storage_bucket_iam_binding" "objectViewer-media" {
  bucket = data.google_storage_bucket.media.name
  members = [
    "serviceAccount:${google_service_account.service-account-sap-app-role-s4test.email}",
    "serviceAccount:${google_service_account.service-account-sap-ascs-role-s4test.email}",
    "serviceAccount:${google_service_account.service-account-sap-db-role-s4test.email}"
  ]
  role = "roles/storage.objectViewer"
}
