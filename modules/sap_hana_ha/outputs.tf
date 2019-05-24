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

output "primary_instance_address" {
  description = "Name of static IP adress to add to primary instance's access config."
  value       = "${google_compute_disk.pd_ssd_primary.name}"
}

output "primary_instance_name" {
  description = "Name of sap primary instance"
  value       = "${google_compute_instance.primary.name}"
}

output "primary_zone" {
  description = "Compute Engine primary instance deployment zone"
  value       = "${google_compute_instance.primary.zone}"
}

output "primary_instance_machine_type" {
  description = "Primary GCE instance/machine type."
  value       = "${google_compute_instance.primary.machine_type}"
}

output "secondary_instance_address" {
  description = "Name of static IP adress to add to secondary instance's access config."
  value       = "${google_compute_disk.pd_ssd_secondary.name}"
}

output "secondary_instance_name" {
  description = "Name of sap secondary instance"
  value       = "${google_compute_instance.secondary.name}"
}

output "secondary_zone" {
  description = "Compute Engine secondary instance deployment zone"
  value       = "${google_compute_instance.secondary.zone}"
}

output "secondary_instance_machine_type" {
  description = "Secondary GCE instance/machine type."
  value       = "${google_compute_instance.secondary.machine_type}"
}
