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
output "scs_instance" {
  description = "SCS instance"
  value       = google_compute_instance.scs_instance.self_link
}
output "ers_instance" {
  description = "ERS instance"
  value       = google_compute_instance.ers_instance.self_link
}
output "nw_vips" {
  description = "NW virtual IPs"
  value       = google_compute_address.nw_vips[*].self_link
}
output "nw_instance_groups" {
  description = "NW Instance Groups"
  value       = google_compute_instance_group.nw_instance_groups[*].self_link
}
output "nw_hc" {
  description = "Health Checks"
  value       = google_compute_health_check.nw_hc[*].self_link
}
output "nw_hc_firewall" {
  description = "Firewall rule for the Health Checks"
  value       = google_compute_firewall.nw_hc_firewall_rule[*].self_link
}
output "nw_regional_backend_services" {
  description = "Backend Services"
  value       = google_compute_region_backend_service.nw_regional_backend_services[*].self_link
}
output "nw_forwarding_rules" {
  description = "Forwarding rules"
  value       = google_compute_forwarding_rule.nw_forwarding_rules[*].self_link
}
