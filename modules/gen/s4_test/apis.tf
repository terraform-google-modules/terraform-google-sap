


resource "google_project_service" "service_dns_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "dns.googleapis.com"
}
