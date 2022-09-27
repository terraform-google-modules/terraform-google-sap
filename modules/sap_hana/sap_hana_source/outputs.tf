output "sap_hana_primary_self_link" {
  description = "SAP HANA self-link for the primary instance created"
  value = google_compute_instance.sap_hana_primary_instance.self_link
}

output "sap_hana_worker_self_links" {
  description = "SAP HANA self-links for the secondary instances created"
  value = google_compute_instance.sap_hana_worker_instances.*.self_link
}
