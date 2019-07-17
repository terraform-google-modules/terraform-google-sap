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

variable "linux_image_family" {
  description = "GCE image family."
}

variable "linux_image_project" {
  description = "Project name containing the linux image."
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = "false"
}

variable "disk_name_0" {
  description = "Name of first disk."
  default     = "sap-maxdb-pd-sd-0"
}

variable "disk_name_1" {
  description = "Name of second disk."
  default     = "sap-maxdb-pd-sd-1"
}

variable "disk_name_2" {
  description = "Name of third disk."
  default     = "sap-maxdb-pd-sd-2"
}

variable "disk_name_3" {
  description = "Name of fourth disk."
  default     = "sap-maxdb-pd-sd-3"
}

variable "disk_name_4" {
  description = "Name of fifth disk."
  default     = "sap-maxdb-pd-sd-4"
}

variable "disk_name_5" {
  description = "Name of sixth disk."
  default     = "sap-maxdb-pd-sd-5"
}

variable "disk_name_6" {
  description = "Name of seventh disk."
  default     = "sap-maxdb-pd-sd-6"
}

variable "device" {
  description = "Device name"
  default     = "boot"
}

variable "device_0" {
  description = "Device name"
  default     = "usrsap"
}

variable "device_1" {
  description = "Device name"
  default     = "swap"
}

variable "device_2" {
  description = "Device name"
  default     = "maxdbroot"
}

variable "device_3" {
  description = "Device name"
  default     = "maxdblog"
}

variable "device_4" {
  description = "Device name"
  default     = "maxdbdata"
}

variable "device_5" {
  description = "Device name"
  default     = "maxdbbackup"
}

variable "device_6" {
  description = "Device name"
  default     = "sapmnt"
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
  description = "Persistent disk size in GB."
  default     = ""
}

variable "pd_standard_size" {
  description = "Persistent disk size in GB"
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

variable "startup_script" {
  description = "Startup script to install SAP Maxdb."
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
