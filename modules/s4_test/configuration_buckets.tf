


resource "google_storage_bucket" "core-connect-dev-configuration" {
  location                    = "US"
  name                        = "core-connect-dev-configuration"
  project                     = data.google_project.sap-project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}


resource "google_storage_bucket_iam_binding" "objectViewer-core-connect-dev-configuration" {
  bucket = google_storage_bucket.core-connect-dev-configuration.name
  members = [
    "serviceAccount:sap-app-role-s4test@core-connect-dev.iam.gserviceaccount.com"
  ]
  role = "roles/storage.objectViewer"
}
