output "sap_nw_self_link" {
  description = "SAP NW self-link for instance created"
  value = google_compute_instance.sap_nw_instance.self_link
}
