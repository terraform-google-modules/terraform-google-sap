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

output "instance_master_name" {
  description = "Name of primary instance"
  value       = "${element(google_compute_instance.master.*.name, 0)}"
}

output "instance_master_zone" {
  description = "Compute Engine primary instance deployment zone"
  value       = "${google_compute_instance.master.*.zone}"
}

output "instance_master_machine_type" {
  description = "instance master type"
  value       = "${google_compute_instance.master.*.machine_type}"
}

output "instance_worker_first_node_name" {
  description = "instance worker first node name"
  value       = "${element(google_compute_instance.worker.*.name, 0)}"
}

output "instance_worker_second_node_name" {
  description = "instance worker second node name"
  value       = "${element(google_compute_instance.worker.*.name, 1)}"
}

output "worker_instance_zone" {
  description = "instance worker zone"
  value       = "${google_compute_instance.worker.*.zone}"
}

output "worker_instance_machine_type" {
  description = "instance worker machine type"
  value       = "${google_compute_instance.worker.*.machine_type}"
}
