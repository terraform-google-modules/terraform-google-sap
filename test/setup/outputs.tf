/**
 * Copyright 2019 Google LLC
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

output "project_id" {
  value = module.project.project_id
}

output "region" {
  value = var.region
}

output "zone" {
  value = var.zone
}

output "primary_zone" {
  value = var.zone
}

output "secondary_zone" {
  value = "us-east4-b"
}

output "subnetwork" {
  value = module.network.subnets_self_links[0]
}

output "sap_hana_instance_number" {
  value = 10
}

output "sap_hana_sid" {
  value = "D01"
}

output "sap_hana_sidadm_uid" {
  value = 900
}

output "sap_hana_sapsys_gid" {
  value = 900
}

output "sap_hana_sidadm_password" {
  value = "MyPassword123"
}

output "sap_hana_system_password" {
  value = "MyPassword123"
}

output "boot_disk_type" {
  value = "pd-ssd"
}

output "boot_disk_size" {
  value = 100
}

output "disk_type" {
  value = "pd-standard"
}

output "swap_size" {
  value = 0
}

output "usr_sap_size" {
  value = 0
}

output "sap_mnt_size" {
  value = 0
}

output "linux_image_family" {
  value = "sles-12-sp3-sap"
}

output "linux_image_project" {
  value = "suse-sap-cloud"
}

output "instance_type" {
  value = "n1-highmem-16"
}

output "primary_instance_name" {
  value = "gcp-sap-ha-1-test"
}

output "secondary_instance_name" {
  value = "gcp-sap-ha-2-test"
}

output "sap_vip" {
  value = "10.10.10.20"
}

output "primary_instance_ip" {
  value = "gcp-primary-instance-ip"
}

output "secondary_instance_ip" {
  value = "gcp-secondary-instance-ip"
}

output "sap_vip_internal_address" {
  value = "sap-vip-internal-address"
}

output "address_name" {
  value = "gcp-sap-test-ip"
}

output "sap_vip_secondary_range" {
  value = ""
}

output "service_account_email" {
  value = google_service_account.int_test.email
}

output "sap_hana_deployment_bucket" {
  value = "bucket_name"
}
