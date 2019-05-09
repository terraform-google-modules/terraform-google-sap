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

# Changed from SCR
variable "project_id" {
  description = "Project name to deploy the resources"
}

variable "instance_name" {
  description = "Compute Engine instance name"
  default     = "sap-hana-simple-example"
}

variable "instance_type" {
  description = "Compute Engine instance Type"

  # Should add minimal instance type here if possible.
}

variable "zone" {
  description = "Compute Engine instance deployment zone"
  default     = "us-central1-b"
}

variable "subnetwork" {
  description = "Compute Engine instance name"
  default     = ""
}

variable "region" {
  description = "Region to deploy the resources"
  default     = "us-central1"
}

variable "linux_image_family" {
  description = "Compute Engine image name"
  default     = "sles-12-sp3-sap"
}

variable "linux_image_project" {
  description = "Project name containing the linux image"
  default     = "suse-sap-cloud"
}

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket"

  # Can default be ignored here
  default = ""
}

# Mod to SCR
variable "sap_deployment_debug" {
  description = "SAP hana deployment debug"
  default     = "false"
}

variable "post_deployment_script" {
  description = "SAP post deployment script"
  default     = ""
}

variable "sap_hana_sid" {
  description = "SAP hana SID"
  default     = "D10"
}

variable "sap_hana_instance_number" {
  description = "SAP hana instance number"
  default     = 10
}

variable "sap_hana_sidadm_password" {
  description = "SAP hana SID admin password"
  default     = "Google123"
}

variable "sap_hana_system_password" {
  description = "SAP hana system password"
  default     = "Google123"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP hana sid adm password"
  default     = 900
}

variable "sap_hana_sapsys_gid" {
  description = "SAP hana sap system gid"
  default     = 900
}

variable "autodelete_disk" {
  description = "Delete backend disk along with instance"
  default     = true
}

variable "boot_disk_size" {
  description = "Root disk size in GB"

  # TODO: Make smaller boot disk size if possible.
  default = 64
}

variable "boot_disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD."
  default     = "pd-ssd"
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = 50
}

variable "pd_standard_size" {
  description = "Persistent disk size in GB"
  default     = 50
}

variable "service_account" {
  description = "Service to run terraform"
}

## Mod to SCR
variable "network_tags" {
  type        = "list"
  description = "List of network tags"
  default     = [""]
}

variable "startup_script" {
  description = "Startup script for VM running SAP HANA."
}

variable "startup_script_custom" {
  description = "Custom startup script. This should only be used with the terraform-google-startup-scripts module."
  default     = ""
}

