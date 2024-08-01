# Copyright 2024 Google LLC
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
  type        = bool
}

variable "ansible_sa_email" {
  default     = ""
  description = "ansible_sa_email"
  type        = string
}

variable "app_disk_export_interfaces_size" {
  default     = 128
  description = "app_disk_export_interfaces_size"
  type        = number
}

variable "app_disk_type" {
  default     = "pd-balanced"
  description = "app_disk_type"
  type        = string
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "hyperdisk-extreme"], var.app_disk_type)
    error_message = "app_disk_type must be one of [\"pd-ssd\", \"pd-balanced\", \"hyperdisk-extreme\"]"
  }
}

variable "app_disk_usr_sap_size" {
  default     = 128
  description = "app_disk_usr_sap_size"
  type        = number
}

variable "app_machine_type" {
  default     = "n1-highem-32"
  description = "app_machine_type"
  type        = string
}

variable "app_sa_email" {
  default     = ""
  description = "app_sa_email"
  type        = string
}

variable "app_sid" {
  default     = "ED1"
  description = "app_sid"
  type        = string
}

variable "app_vm_names" {
  default     = []
  description = "app_vm_names"
  type        = list(any)
}

variable "app_vms_multiplier" {
  default     = 1
  description = "Multiplies app VMs. E.g. if there is 2 VMs then with value 3 each VM will be multiplied by 3 (so there will be 6 total VMs)"
  type        = string
}

variable "application_secret_name" {
  default     = "default"
  description = "application_secret_name"
  type        = string
}

variable "ascs_disk_type" {
  default     = "pd-balanced"
  description = "ascs_disk_type"
  type        = string
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "hyperdisk-extreme"], var.ascs_disk_type)
    error_message = "ascs_disk_type must be one of [\"pd-ssd\", \"pd-balanced\", \"hyperdisk-extreme\"]"
  }
}

variable "ascs_disk_usr_sap_size" {
  default     = 128
  description = "ascs_disk_usr_sap_size"
  type        = number
}

variable "ascs_ilb_healthcheck_port" {
  default     = 60001
  description = "ascs_ilb_healthcheck_port"
  type        = number
}

variable "ascs_machine_type" {
  default     = "n1-standard-8"
  description = "ascs_machine_type"
  type        = string
}

variable "ascs_sa_email" {
  default     = ""
  description = "ascs_sa_email"
  type        = string
}

variable "ascs_vm_names" {
  default     = []
  description = "ascs_vm_names"
  type        = list(any)
}

variable "configuration_bucket_name" {
  default     = ""
  description = "configuration_bucket_name"
  type        = string
}

variable "create_comms_firewall" {
  default     = true
  description = "create_comms_firewall"
  type        = bool
}

variable "custom_tags" {
  default     = []
  description = "custom_tags"
  type        = list(any)
}

variable "data_stripe_size" {
  default     = "256k"
  description = "data_stripe_size"
  type        = string
}

variable "db_data_disk_type" {
  default     = "pd-balanced"
  description = "db_data_disk_type"
  type        = string
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "hyperdisk-extreme"], var.db_data_disk_type)
    error_message = "db_data_disk_type must be one of [\"pd-ssd\", \"pd-balanced\", \"hyperdisk-extreme\"]"
  }
}

variable "db_disk_backup_size" {
  default     = 128
  description = "db_disk_backup_size"
  type        = number
}

variable "db_disk_hana_data_size" {
  default     = 249
  description = "db_disk_hana_data_size"
  type        = number
}

variable "db_disk_hana_log_size" {
  default     = 104
  description = "db_disk_hana_log_size"
  type        = number
}

variable "db_disk_hana_shared_size" {
  default     = 208
  description = "db_disk_hana_shared_size"
  type        = number
}

variable "db_disk_type" {
  default     = "pd-balanced"
  description = "Disk type for the non log/data disks."
  type        = string
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "hyperdisk-extreme"], var.db_disk_type)
    error_message = "db_disk_type must be one of [\"pd-ssd\", \"pd-balanced\", \"hyperdisk-extreme\"]"
  }
}

variable "db_disk_usr_sap_size" {
  default     = 32
  description = "db_disk_usr_sap_size"
  type        = number
}

variable "db_ilb_healthcheck_port" {
  default     = 60000
  description = "db_ilb_healthcheck_port"
  type        = number
}

variable "db_log_disk_type" {
  default     = "pd-balanced"
  description = "db_log_disk_type"
  type        = string
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "hyperdisk-extreme"], var.db_log_disk_type)
    error_message = "db_log_disk_type must be one of [\"pd-ssd\", \"pd-balanced\", \"hyperdisk-extreme\"]"
  }
}

variable "db_machine_type" {
  default     = "n1-highmem-32"
  description = "db_machine_type"
  type        = string
}

variable "db_sa_email" {
  default     = ""
  description = "db_sa_email"
  type        = string
}

variable "db_sid" {
  default     = "HD1"
  description = "db_sid"
  type        = string
}

variable "db_vm_names" {
  default     = []
  description = "db_vm_names"
  type        = list(any)
}

variable "deployment_name" {
  description = "deployment_name"
  type        = string
}

variable "dns_zone_name_suffix" {
  default     = "gcp.sapcloud.goog."
  description = "dns_zone_name_suffix"
  type        = string
}

variable "ers_ilb_healthcheck_port" {
  default     = 60002
  description = "ers_ilb_healthcheck_port"
  type        = number
}

variable "existing_dns_zone_name" {
  default     = ""
  description = "existing_dns_zone_name"
  type        = string
}

variable "deployment_has_dns" {
  default     = true
  description = "Set to false to deploy without a DNS zone"
  type        = bool
}

variable "filestore_gb" {
  default     = 1024
  description = "filestore_gb"
  type        = number
}

variable "filestore_location" {
  description = "filestore_location"
  type        = string
}

variable "filestore_tier" {
  default     = "ENTERPRISE"
  description = "filestore_tier"
  type        = string
}

variable "fstore_mount_point" {
  default     = ""
  description = "Optional - default is empty. NFS mount point of the nfs to use. If none is provided one will be created."
  type        = string
}

variable "gcp_project_id" {
  description = "gcp_project_id"
  type        = string
}

variable "hana_secret_name" {
  default     = "default"
  description = "hana_secret_name"
  type        = string
}

variable "is_test" {
  default     = "false"
  description = "is_test"
  type        = string
}

variable "log_stripe_size" {
  default     = "64k"
  description = "log_stripe_size"
  type        = string
}

variable "media_bucket_name" {
  description = "media_bucket_name"
  type        = string
}

variable "network_project" {
  default     = ""
  description = "network_project"
  type        = string
}

variable "number_data_disks" {
  default     = 1
  description = "Optional - default is 1. Number of disks to use for data volume striping (if larger than 1)."
  type        = number
}

variable "number_log_disks" {
  default     = 1
  description = "Optional - default is 1. Number of disks to use for log volume striping (if larger than 1)."
  type        = number
}

variable "package_location" {
  default     = "gs://cloudsapdeploy/deployments/latest"
  description = "package_location"
  type        = string
}

variable "primary_startup_url" {
  default     = "gs://cloudsapdeploy/deployments/latest/startup/ansible_runner_startup.sh"
  description = "primary_startup_url"
  type        = string
}

variable "public_ansible_runner_ip" {
  default     = true
  description = "public_ansible_runner_ip"
  type        = bool
}

variable "public_ip" {
  default     = false
  description = "public_ip"
  type        = bool
}

variable "region_name" {
  description = "region_name"
  type        = string
}

variable "sap_boot_disk_image" {
  default     = "projects/rhel-sap-cloud/global/images/rhel-8-4-sap-v20220719"
  description = "sap_boot_disk_image"
  type        = string
}

variable "sap_boot_disk_image_app" {
  default     = ""
  description = "sap_boot_disk_image_app"
  type        = string
}

variable "sap_boot_disk_image_ascs" {
  default     = ""
  description = "sap_boot_disk_image_ascs"
  type        = string
}

variable "sap_boot_disk_image_db" {
  default     = ""
  description = "sap_boot_disk_image_db"
  type        = string
}

variable "sap_instance_id_app" {
  default     = "10"
  description = "sap_instance_id_app"
  type        = string
}

variable "sap_instance_id_ascs" {
  default     = "11"
  description = "sap_instance_id_ascs"
  type        = string
}

variable "sap_instance_id_db" {
  default     = "00"
  description = "sap_instance_id_db"
  type        = string
}

variable "sap_instance_id_ers" {
  default     = "12"
  description = "sap_instance_id_ers"
  type        = string
}

variable "sap_version" {
  default     = "2021"
  description = "sap_version"
  type        = string
}

variable "subnet_name" {
  default     = "default"
  description = "subnet_name"
  type        = string
}

variable "virtualize_disks" {
  default     = true
  description = "virtualize_disks"
  type        = bool
}

variable "vm_prefix" {
  default     = "sapha"
  description = "vm_prefix"
  type        = string
}

variable "vpc_name" {
  default     = "default"
  description = "vpc_name"
  type        = string
}

variable "zone1_name" {
  description = "zone1_name"
  type        = string
}

variable "zone2_name" {
  description = "zone2_name"
  type        = string
}

