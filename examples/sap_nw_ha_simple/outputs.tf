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
output "sap_nw_scs_primary_self_link" {
  description = "SAP NW SCS self-link for the instance created"
  value       = module.sap_nw_ha.scs_instance
}

output "sap_nw_ers_worker_self_links" {
  description = "SAP NW ERS self-links for the instance created"
  value       = module.sap_nw_ha.ers_instance
}
