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

variable "primary_instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "secondary_instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "primary_zone" {
  description = "The primary zone that the instance should be created in."
}

variable "secondary_zone" {
  description = "The secondary zone that the instance should be created in."
}

variable "instance_type" {
  description = "The GCE instance/machine type."
}

variable "subnetwork" {
  description = "Compute Engine instance name"
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
  description = "Project name containing the linux image."
}

variable "sap_hana_deployment_bucket" {
  description = "SAP HANA post deployment script. Must be a gs:// or https:// link to the script."
}

variable "sap_deployment_debug" {
  description = "Debug flag for SAP HANA deployment."
  default     = "false"
}

variable "post_deployment_script" {
  description = "SAP post deployment script"
}

variable "sap_hana_sid" {
  description = "SAP HANA System Identifier. When using the SID to enter a user session, like this for example, `su - [SID]adm`, make sure that [SID] is in lower case."
}

variable "sap_hana_instance_number" {
  description = "SAP HANA instance number"
}

variable "sap_hana_sidadm_password" {
  description = "SAP HANA System Identifier Admin password"
}

variable "sap_hana_system_password" {
  description = "SAP HANA system password"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP HANA System Identifier Admin UID"
}

variable "sap_hana_sapsys_gid" {
  description = "SAP HANA SAP System GID"
}

variable "sap_vip" {
  description = "SAP VIP"
}

variable "sap_vip_secondary_range" {
  description = "SAP seconday VIP range"
}

variable "autodelete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted."
  default     = "false"
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
}

variable "boot_disk_type" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "disk_type_0" {
  description = "The GCE data disk type. May be set to pd-ssd."
  default     = "pd-ssd"
}

variable "disk_type_1" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD)."
  default     = "pd-standard"
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = ""
}

variable "pd_hdd_size" {
  description = "Persistent disk size in GB"
  default     = ""
}

variable "disk_name_0" {
  description = "Name of first disk."
  default     = "sap-hana-pd-sd-0"
}

variable "disk_name_1" {
  description = "Name of second disk."
  default     = "sap-hana-pd-sd-1"
}

variable "disk_name_2" {
  description = "Name of third disk."
  default     = "sap-hana-pd-sd-2"
}

variable "disk_name_3" {
  description = "Name of fourth disk."
  default     = "sap-hana-pd-sd-3"
}

variable "pd_kms_key" {
  description = "Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used.."
  default     = null
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "network_tags" {
  type        = list
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
  default     = true
}

variable "primary_instance_ip" {
  description = "Primary instance ip address"
  default     = ""
}

variable "secondary_instance_ip" {
  description = "Secondary instance ip address"
  default     = ""
}

variable "sap_vip_internal_address" {
  description = "Name of static IP adress to add to the instance's access config."
}

variable "startup_script_1" {
  description = "Startup script to install SAP HANA."
}

variable "startup_script_2" {
  description = "Startup script to install SAP HANA."
}

variable "primary_instance_internal_ip" {
  description = "Primary instance private ip address"
  default     = ""
}

variable "secondary_instance_internal_ip" {
  description = "Secondary instance private ip address"
  default     = ""
}