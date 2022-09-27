output "sap_hana_primary_self_link" {
  description = "Self-link for the primary SAP HANA Scalout instance created."
  value = google_compute_instance.sap_hana_scaleout_primary_instance.self_link
}
output "hana_scaleout_worker_self_links" {
  description = "List of self-links for the hana scaleout workers created"
  value = google_compute_instance.sap_hana_scaleout_worker_instances.*.self_link
}
output "hana_scaleout_standby_self_links" {
  description = "List of self-links for the hana scaleout standbys created"
  value = google_compute_instance.sap_hana_scaleout_standby_instances.*.self_link
}
