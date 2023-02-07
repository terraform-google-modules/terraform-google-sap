data "google_storage_bucket" "media" {
  name     = var.media_bucket_name
  provider = google-beta
}

resource "google_storage_bucket_iam_member" "objectviewer_media_1" {
  bucket = data.google_storage_bucket.media.name
  member = "serviceAccount:${google_service_account.service_account_app.email}"
  role   = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_member" "objectviewer_media_2" {
  bucket = data.google_storage_bucket.media.name
  member = "serviceAccount:${google_service_account.service_account_ascs.email}"
  role   = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_member" "objectviewer_media_3" {
  bucket = data.google_storage_bucket.media.name
  member = "serviceAccount:${google_service_account.service_account_db.email}"
  role   = "roles/storage.objectViewer"
}
