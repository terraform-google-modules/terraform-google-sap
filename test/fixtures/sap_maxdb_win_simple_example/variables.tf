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

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "zone" {
  description = "The zone that the instance should be created in."
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "instance_type" {
  description = "The GCE instance/machine type."
}

variable "windows_image_family" {
  description = "Compute Engine image name"
}

variable "windows_image_project" {
  description = "Project name containing the linux image"
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = "false"
}

variable "disk_type_0" {
  description = "The GCE data disk type. May be set to pd-ssd."
}

variable "disk_type_1" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD)."
}

variable "boot_disk_size" {
  description = "Root disk size in GB."
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "pd_ssd_size" {
  description = "Persistent  SSD disk size in GB."
  default     = ""
}

variable "pd_hdd_size" {
  description = "Persistent standard disk size in GB"
  default     = ""
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
}

variable "sap_deployment_debug" {
  description = "Debug flag for SAP Maxdb deployment."
  default     = "false"
}

variable "post_deployment_script" {
  description = "SAP Maxdb post deployment script. Must be a gs:// or https:// link to the script."
  default     = ""
}

variable "usr_sap_size" {
  description = "USR SAP size"
}

variable "maxdbRootSize" {
  description = "The size in GB of MaxDB (D:), which is the root directory of the database instance."
}

variable "swap_size" {
  description = "SWAP Size"
}

variable "maxdbDataSize" {
  description = "The size of MaxDB Data (E:), which holds the database data files."
}

variable "maxdbLogSize" {
  description = "The size of MaxDB Log (L:), which holds the database transaction logs."
}

variable "maxdbBackupSize" {
  description = "The size of the Backup (X:) volume."
}

variable "maxdbDataSSD" {
  description = "Specifies whether the data drive uses an SSD persistent disk (Yes) or an HDD persistent disk (No). "
}

variable "maxdbLogSSD" {
  description = "Specifies whether the log drive uses an SSD persistent disk (Yes) or an HDD persistent disk (No)."
}

variable "swapmntSize" {
  description = "SAP mount size"
}

variable "sap_maxdb_sid" {
  description = "sap max db sid"
}

variable "sap_maxdb_deployment_bucket" {
  description = "MAXDB deployment bucket."
  default     = "maxdb/max-db"
}
