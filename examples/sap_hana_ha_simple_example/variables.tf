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
  default     = "sap-hana-ha-terra-1"
}

variable "secondary_instance_name" {
  default     = "sap-hana-ha-terra-2"
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "primary_zone" {
  description = "The primary zone that the instance should be created in."
  default     = "us-central1-a"
}

variable "secondary_zone" {
  description = "The secondary zone that the instance should be created in."
  default     = "us-central1-b"
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

variable "post_deployment_script" {
  description = "SAP HANA post deployment script. Must be a gs:// or https:// link to the script."
  default     = ""
}

variable "sap_hana_sid" {
  description = "SAP HANA System Identifier"
  default     = "D10"
}

variable "sap_hana_sidadm_password" {
  description = "SAP HANA System Identifier Admin password"
}

variable "sap_hana_system_password" {
  description = "SAP HANA system password"
}

variable "sap_hana_sidadm_uid" {
  description = "SAP HANA System Identifier Admin UID"
  default     = 900
}

variable "sap_hana_sapsys_gid" {
  description = "SAP HANA SAP System GID"
  default     = 900
}

variable "sap_vip" {
  description = "SAP VIP"
}

variable "sap_hana_instance_number" {
  description = "SAP HANA instance number"
  default     = 10
}

variable "sap_vip_secondary_range" {
  description = "SAP seconday VIP range"
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
}

variable "boot_disk_type" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
}

variable "disk_type" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags to attach to the instance."
  default     = []
}

variable "primary_instance_ip" {
  description = "Primary instance ip address"
}

variable "secondary_instance_ip" {
  description = "Secondary instance ip address"
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
