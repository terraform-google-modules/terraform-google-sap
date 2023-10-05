# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "allow_stopping_for_update" {
  default     = true
  description = "allow_stopping_for_update"
}

variable "app_disk_export_interfaces_size" {
  default     = 128
  description = "app_disk_export_interfaces_size"
}

variable "app_disk_usr_sap_size" {
  default     = 128
  description = "app_disk_usr_sap_size"
}

variable "app_machine_type" {
  default     = "n1-highem-32"
  description = "app_machine_type"
}

variable "app_sid" {
  default     = "ED1"
  description = "app_sid"
}

variable "app_vms_multiplier" {
  default     = 1
  description = "Multiplies app VMs. E.g. if there is 2 VMs then with value 3 each VM will be multiplied by 3 (so there will be 6 total VMs)"
}

variable "application_secret_name" {
  default     = "default"
  description = "application_secret_name"
}

variable "ascs_disk_usr_sap_size" {
  default     = 128
  description = "ascs_disk_usr_sap_size"
}

variable "ascs_ilb_healthcheck_port" {
  default     = 60001
  description = "ascs_ilb_healthcheck_port"
}

variable "ascs_machine_type" {
  default     = "n1-standard-8"
  description = "ascs_machine_type"
}

variable "db_disk_export_backup_size" {
  default     = 128
  description = "db_disk_export_backup_size"
}

variable "db_disk_hana_data_size" {
  default     = 249
  description = "db_disk_hana_data_size"
}

variable "db_disk_hana_log_size" {
  default     = 104
  description = "db_disk_hana_log_size"
}

variable "db_disk_hana_restore_size" {
  default     = 128
  description = "db_disk_hana_restore_size"
}

variable "db_disk_hana_shared_size" {
  default     = 208
  description = "db_disk_hana_shared_size"
}

variable "db_disk_usr_sap_size" {
  default     = 32
  description = "db_disk_usr_sap_size"
}

variable "db_ilb_healthcheck_port" {
  default     = 60000
  description = "db_ilb_healthcheck_port"
}

variable "db_machine_type" {
  default     = "n1-highmem-32"
  description = "db_machine_type"
}

variable "db_sid" {
  default     = "HD1"
  description = "db_sid"
}

variable "deployment_name" {
  description = "deployment_name"
}

variable "disk_type" {
  default     = "pd-balanced"
  description = "disk_type"
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "hyperdisk-extreme"], var.disk_type)
    error_message = "disk_type must be one of [\"pd-ssd\", \"pd-balanced\", \"hyperdisk-extreme\"]"
  }

}

variable "dns_zone_name_suffix" {
  default     = "gcp.sapcloud.goog."
  description = "dns_zone_name_suffix"
}

variable "ers_ilb_healthcheck_port" {
  default     = 60002
  description = "ers_ilb_healthcheck_port"
}

variable "existing_dns_zone_name" {
  default     = ""
  description = "existing_dns_zone_name"
}

variable "filestore_gb" {
  default     = 1024
  description = "filestore_gb"
}

variable "filestore_location" {
  description = "filestore_location"
}

variable "filestore_tier" {
  default     = "ENTERPRISE"
  description = "filestore_tier"
}

variable "gcp_project_id" {
  description = "gcp_project_id"
}

variable "hana_secret_name" {
  default     = "default"
  description = "hana_secret_name"
}

variable "media_bucket_name" {
  description = "media_bucket_name"
}

variable "package_location" {
  default     = "gs://cloudsapdeploy/deployments/latest"
  description = "package_location"
}

variable "primary_startup_url" {
  default     = "gs://cloudsapdeploy/deployments/latest/startup/ansible_runner_startup.sh"
  description = "primary_startup_url"
}

variable "public_ip" {
  default     = false
  description = "public_ip"
}

variable "region_name" {
  description = "region_name"
}

variable "sap_boot_disk_image" {
  default     = "projects/rhel-sap-cloud/global/images/rhel-8-4-sap-v20220719"
  description = "sap_boot_disk_image"
}

variable "sap_boot_disk_image_app" {
  default     = ""
  description = "sap_boot_disk_image_app"
}

variable "sap_boot_disk_image_ascs" {
  default     = ""
  description = "sap_boot_disk_image_ascs"
}

variable "sap_boot_disk_image_db" {
  default     = ""
  description = "sap_boot_disk_image_db"
}

variable "sap_instance_id_app" {
  default     = "10"
  description = "sap_instance_id_app"
}

variable "sap_instance_id_ascs" {
  default     = "11"
  description = "sap_instance_id_ascs"
}

variable "sap_instance_id_db" {
  default     = "00"
  description = "sap_instance_id_db"
}

variable "sap_instance_id_ers" {
  default     = "12"
  description = "sap_instance_id_ers"
}

variable "sap_version" {
  default     = "2021"
  description = "sap_version"
}

variable "subnet_name" {
  default     = "default"
  description = "subnet_name"
}

variable "vm_prefix" {
  default     = "sapha"
  description = "vm_prefix"
}

variable "vpc_name" {
  default     = "default"
  description = "vpc_name"
}

variable "zone1_name" {
  description = "zone1_name"
}

variable "zone2_name" {
  description = "zone2_name"
}
