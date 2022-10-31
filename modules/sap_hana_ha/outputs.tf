output "sap_hana_ha_primary_instance_self_link" {
  description = "Self-link for the primary SAP HANA HA instance created."
  value = google_compute_instance.sap_hana_ha_primary_instance.self_link
}
output "sap_hana_ha_secondary_instance_self_link" {
  description = "Self-link for the secondary SAP HANA HA instance created."
  value = google_compute_instance.sap_hana_ha_secondary_instance.self_link
}
output "sap_hana_ha_loadbalander_link" {
  description = "Link to the optional load balancer"
  value = google_compute_region_backend_service.sap_hana_ha_loadbalancer.*.self_link
}
output "sap_hana_ha_firewall_link" {
  description = "Link to the optional fire wall"
  value = google_compute_firewall.sap_hana_ha_vpc_firewall.*.self_link
}
