/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
output "sap_hana_ha_primary_instance_self_link" {
  description = "Self-link for the primary SAP HANA HA instance created."
  value       = google_compute_instance.sap_hana_ha_primary_instance.self_link
}
output "sap_hana_ha_primary_worker_self_links" {
  description = "Self-link for the worker nodes in the primary SAP HANA HA instance."
  value       = google_compute_instance.sap_hana_ha_primary_workers[*].self_link
}
output "sap_hana_ha_secondary_instance_self_link" {
  description = "Self-link for the secondary SAP HANA HA instance created."
  value       = google_compute_instance.sap_hana_ha_secondary_instance.self_link
}
output "sap_hana_ha_secondary_worker_self_links" {
  description = "Self-link for the worker nodes in the secondary SAP HANA HA instance."
  value       = google_compute_instance.sap_hana_ha_secondary_workers[*].self_link
}
output "sap_hana_ha_loadbalander_link" {
  description = "Link to the optional load balancer"
  value       = google_compute_region_backend_service.sap_hana_ha_loadbalancer[*].self_link
}
output "sap_hana_ha_firewall_link" {
  description = "Link to the optional fire wall"
  value       = google_compute_firewall.sap_hana_ha_vpc_firewall[*].self_link
}
