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
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
  default     = "us-central1"
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  default     = "sap-hana-simple-example"
}

variable "instance_type" {
  description = "The GCE instance/machine type."

  # TODO:
  # Should add minimal instance type here if possible.
}

variable "linux_image_family" {
  description = "GCE linux image family."
}

variable "linux_image_project" {
  description = "Project name containing the linux image."
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = true
}

variable "disk_type" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "boot_disk_size" {
  description = "Root disk size in GB"

  # TODO: Make smaller boot disk size if possible.
  default = 64
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
  default     = "pd-ssd"
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = 450
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "address_name" {
  description = "Name of static IP adress to add to the instance's access config."
  default     = "gcp-sap-hana-ip"
}

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket."
}

variable "sap_deployment_debug" {
  description = "Debug flag for SAP HANA deployment."
  default     = "false"
}

variable "post_deployment_script" {
  description = "SAP HANA post deployment script"
  default     = ""
}

variable "startup_script" {
  description = "Startup script to install SAP HANA."
}

variable "sap_hana_sid" {
  description = "SAP HANA System Identifier"
  default     = "D10"
}

variable "sap_hana_instance_number" {
  description = "SAP HANA instance number"
  default     = 10
}

variable "sap_hana_sidadm_password" {
  description = "SAP HANA System Identifier Admin password"
  default     = "Google123"
}

variable "sap_hana_system_password" {
  description = "SAP HANA system password"
  default     = "Google123"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP HANA System Identifier Admin UID"
  default     = 900
}

variable "sap_hana_sapsys_gid" {
  description = "SAP HANA SAP System GID"
  default     = 900
}
