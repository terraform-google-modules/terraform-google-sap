/**
 * Copyright 2018 Google LLC
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
output "instance_name" {
  description = "Name of sap ase instance"
  value       = "${element(compact(google_compute_instance.master.*.name),0)}"
}

output "zone" {
  description = "Compute Engine instance deployment zone"
  value       = "${element(compact(google_compute_instance.master.*.zone),0)}"
}

output "instance_machine_type" {
  description = "Primary GCE instance/machine type."
  value       = "${element(compact(google_compute_instance.master.*.machine_type),0)}"
}
