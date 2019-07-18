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
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "pd_standard_size" {
  description = "Persistant standard disk size in GB"
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

variable "post_deployment_script" {
  description = "SAP HANA post deployment script. Must be a gs:// or https:// link to the script."
  default     = ""
}

variable "startup_script" {
  description = "Startup script to install SAP HANA."
}

variable "usr_sap_size" {
  description = "USR SAP size"
}

variable "swap_mnt_size" {
  description = "SAP mount size"
}

variable "swap_size" {
  description = "SWAP Size"
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
  default     = "db2sid"
}

variable "device_2" {
  description = "Device name"
  default     = "db2dump"
}

variable "device_3" {
  description = "Device name"
  default     = "db2home"
}

variable "device_4" {
  description = "Device name"
  default     = "db2saptmp"
}

variable "device_5" {
  description = "Device name"
  default     = "db2log"
}

variable "device_6" {
  description = "Device name"
  default     = "db2sapdata"
}

variable "device_7" {
  description = "Device name"
  default     = "db2backup"
}

variable "device_8" {
  description = "Device name"
  default     = "sapmnt"
}

variable "device_9" {
  description = "Device name"
  default     = "swap"
}

variable "db2_sid" {
  description = "db2 sid"
}

variable "db2dump_size" {
  description = "db2 dump size"
}

variable "db2home_size" {
  description = "db2 home"
}

variable "db2saptmp_size" {
  description = "db2 sap temp size"
}

variable "db2log_size" {
  description = "db2 log size"
}

variable "db2log_ssd" {
  description = "db2 log ssd"
}

variable "db2sapdata_size" {
  description = "Db2 sap data size "
}

variable "db2backup_size" {
  description = "Db2 backup size"
}

variable "db2sid_size" {
  description = "DB2 sid size"
}

variable "db2sapdata_ssd" {
  description = "Db2 sap data ssd."
}
