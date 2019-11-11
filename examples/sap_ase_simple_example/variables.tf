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
  default     = "pd-ssd"
}

variable "pd_ssd_size" {
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

variable "sap_mnt_size" {
  description = "SAP mount size"
}

variable "swap_size" {
  description = "SWAP Size"
}

variable "aseSID" {
  description = "The database instance ID."
}

variable "asesidSize" {
  description = "The size in GB of /sybase/[DBSID], which is the root directory of the database instance. In the deployed VM, this volume is labeled ASE."
}

variable "asediagSize" {
  description = "The size of /sybase/[DBSID]/sapdiag, which holds the diagnostic tablespace for SAPTOOLS."
}

variable "asesaptempSize" {
  description = "The size of /sybase/[DBSID]/saptmp, which holds the database temporary table space."
}

variable "asesapdataSize" {
  description = "The size of /sybase/[DBSID]/sapdata, which holds the database data files."
}

variable "aselogSize" {
  description = "The size of /sybase/[DBSID]logdir, which holds the database transaction logs."
}

variable "asebackupSize" {
  description = "The size of the /sybasebackup volume. If set to 0 or omitted, no disk is created."
}

variable "asesapdataSSD" {
  description = "The SSD toggle for the data drive. If set to true, the data disk will be SSD."
}

variable "aselogSSD" {
  description = "The SSD toggle for the log drive. If set to true, the log disk will be SSD."
}

variable "sap_ase_sid" {
  description = "Sap Ase SID."
}

variable "device_0" {
  description = "Device name"
  default     = "usrsap"
}

variable "device_1" {
  description = "Device name"
  default     = "sapmnt"
}

variable "device_2" {
  description = "Device name"
  default     = "swap"
}

variable "device_3" {
  description = "Device name"
  default     = "asesid"
}

variable "device_4" {
  description = "Device name"
  default     = "asesapdata"
}

variable "device_5" {
  description = "Device name"
  default     = "aselog"
}

variable "device_6" {
  description = "Device name"
  default     = "asesaptemp"
}

variable "device_7" {
  description = "Device name"
  default     = "asesapdiag"
}

variable "device_8" {
  description = "Device name"
  default     = "asebackup"
}

variable "instance_count_master" {
  description = "Compute Engine instance count"
}

variable "public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
  default     = false
  type        = bool
}
