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
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "instance_type" {
  description = "The GCE instance/machine type."
}

variable "zone" {
  description = "The zone that the instance should be created in."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "project_id" {
  description = "The ID of the project in which the resources will be deployed."
}

variable "region" {
  description = "Region to deploy the resources. Should be in the same region as the zone."
}

variable "linux_image_family" {
  description = "GCE image family."
}

variable "linux_image_project" {
  description = "Project name containing the linux image"
}

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket"
}

variable "post_deployment_script" {
  description = "SAP post deployment script"
  default     = ""
}

variable "sap_hana_sid" {
  description = "SAP HANA System Identifier"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP HANA System Identifier Admin UID"
  default     = 900
}

variable "sap_hana_sapsys_gid" {
  description = "SAP HANA SAP System GID"
  default     = 900
}

variable "sap_hana_instance_number" {
  description = "SAP HANA instance number"
}

variable "sap_hana_sidadm_password" {
  description = "SAP hana SID admin password"
}

variable "sap_hana_system_password" {
  description = "SAP hana system password"
}

variable "sap_hana_scaleout_nodes" {
  description = "SAP hana scaleout nodes"
}

variable "instance_count_master" {
  description = "Compute Engine instance count"
}

variable "instance_count_worker" {
  description = "Compute Engine instance count"
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = "false"
}

variable "boot_disk_size" {
  description = "Root disk size in GB."
}

variable "boot_disk_type" {
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "disk_type_0" {
  description = "The GCE data disk type. May be set to pd-ssd."
  default     = ""
}

variable "disk_type_1" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD)."
  default     = ""
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = ""
}

variable "pd_hdd_size" {
  description = "Persistent Standard disk size in GB"
  default     = ""
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "startup_script_1" {
  description = "Startup script to install SAP HANA."
}

variable "startup_script_2" {
  description = "Startup script to install SAP HANA."
}
