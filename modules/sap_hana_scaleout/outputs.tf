/**
 * Copyright 2022 Google LLC
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
