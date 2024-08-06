output "sap_maxdb_self_link" {
  description = "SAP MaxDB self-link for instance created"
  value       = google_compute_instance.sap_maxdb.self_link
}
