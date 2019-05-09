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

variable "instance_name" {
  description = "Compute Engine instance name"
}

variable "instance_type" {
  description = "Compute Engine instance Type"
}

variable "zone" {
  description = "Compute Engine instance deployment zone"
}

variable "subnetwork" {
  description = "Compute Engine instance name"
}

variable "project_id" {
  description = "Project id to deploy the resources"
}

variable "region" {
  description = "Region to deploy the resources"
}

variable "linux_image_family" {
  description = "Compute Engine image name"
}

variable "linux_image_project" {
  description = "Project name containing the linux image"
}

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket"
}

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
}

variable "sap_hana_instance_number" {
  description = "SAP hana instance number"
}

variable "sap_hana_sidadm_password" {
  description = "SAP hana SID admin password"
}

variable "sap_hana_system_password" {
  description = "SAP hana system password"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP hana sid adm password"
}

variable "sap_hana_sapsys_gid" {
  description = "SAP hana sap system gid"
}

variable "autodelete_disk" {
  description = "Delete backend disk along with instance"
  default     = true
}

variable "disk_name_0" {
  description = "Name of first disk"
  default = "sap-hana-pd-sd-0"
}

variable "disk_name_1" {
  description = "Name of second disk"
  default = "sap-hana-pd-sd-1"
}

variable "disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD."
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
}

variable "boot_disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD."
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
}

variable "service_account" {
  description = "Service to run the terrform"
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags"
  default     = []
}

variable "address_name" {
  description = "Name of adress to add to the instance's access config"
  default = "gcp-sap-hana-ip"
}

variable "startup_script" {
  description = "Startup script for VM running SAP HANA."
}

# TODO: Delete if not necessary
variable "startup_script_custom" {
  description = "Custom startup script to be loaded as metadata. This should only be used with the terraform-google-startup-scripts module."
  default     = ""
}
