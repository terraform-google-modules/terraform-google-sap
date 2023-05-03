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
  default     = 256
  description = "app_disk_usr_sap_size"
}

variable "app_machine_type" {
  default     = "e2-standard-32"
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

variable "ascs_disk_usr_sap_size" {
  default     = 256
  description = "ascs_disk_usr_sap_size"
}

variable "ascs_ilb_healthcheck_port" {
  default     = 80
  description = "ascs_ilb_healthcheck_port"
}

variable "ascs_machine_type" {
  default     = "e2-standard-32"
  description = "ascs_machine_type"
}

variable "db_disk_export_backup_size" {
  default     = 256
  description = "db_disk_export_backup_size"
}

variable "db_disk_hana_data_size" {
  default     = 256
  description = "db_disk_hana_data_size"
}

variable "db_disk_hana_log_size" {
  default     = 256
  description = "db_disk_hana_log_size"
}

variable "db_disk_hana_restore_size" {
  default     = 512
  description = "db_disk_hana_restore_size"
}

variable "db_disk_hana_shared_size" {
  default     = 256
  description = "db_disk_hana_shared_size"
}

variable "db_disk_usr_sap_size" {
  default     = 128
  description = "db_disk_usr_sap_size"
}

variable "db_ilb_healthcheck_port" {
  default     = 8080
  description = "db_ilb_healthcheck_port"
}

variable "db_machine_type" {
  default     = "e2-standard-32"
  description = "db_machine_type"
}

variable "db_sid" {
  default     = "HD1"
  description = "db_sid"
}

variable "deployment_name" {
  default     = "s4ha"
  description = "deployment_name"
}

variable "dns_zone_name_suffix" {
  default     = "gcp.sapcloud.goog."
  description = "dns_zone_name_suffix"
}

variable "ers_ilb_healthcheck_port" {
  default     = 8080
  description = "ers_ilb_healthcheck_port"
}

variable "gcp_project_id" {
  default     = "core-connect-dev"
  description = "gcp_project_id"
}

variable "media_bucket_name" {
  default     = "core-connect-dev-sap-installation-media"
  description = "media_bucket_name"
}

variable "package_location" {
  default     = "gs://cloudsapdeploytesting/wlm/continuous"
  description = "package_location"
}

variable "primary_startup_url" {
  default     = "gs://cloudsapdeploytesting/wlm/continuous/startup.sh"
  description = "primary_startup_url"
}

variable "region_name" {
  default     = "us-central1"
  description = "region_name"
}

variable "sap_boot_disk_image" {
  default     = "projects/rhel-sap-cloud/global/images/rhel-8-4-sap-v20220719"
  description = "sap_boot_disk_image"
}

variable "subnet_name" {
  default     = "s4test-sap-s4-test"
  description = "subnet_name"
}

variable "vm_prefix" {
  default     = "sapd"
  description = "vm_prefix"
}

variable "vpc_name" {
  default     = "s4test-sap-s4-test"
  description = "vpc_name"
}

variable "zone1_name" {
  default     = "us-central1-a"
  description = "zone1_name"
}

variable "zone2_name" {
  default     = "us-central1-b"
  description = "zone2_name"
}
