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

variable "primary_instance" {
  description = "Compute Engine instance name"
}

variable "secondary_instance" {
  description = "Compute Engine instance name"
}

variable "primary_zone" {
  description = "Primary Compute Engine instance deployment zone"
}

variable "secondary_zone" {
  description = "Secondary Compute Engine instance deployment zone"
}

variable "instance_type" {
  description = "Compute Engine instance Type"
}

variable "subnetwork" {
  description = "Compute Engine instance name"
}

variable "project_id" {
  description = "Project name to deploy the resources"
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
}

variable "post_deployment_script" {
  description = "SAP post deployment script"
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

variable "sap_vip" {
  description = "SAP VIP"
}

variable "sap_vip_secondary_range" {
  description = "SAP seconday VIP range"
}

variable "autodelete_disk" {
  description = "Delete backend disk along with instance"
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

variable "pd_standard_size" {
  description = "Persistent disk size in GB"
}

variable "service_account" {
  description = "Service to run the terrform"
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags"
}

variable "primary_instance_ip" {
  description = "gcp primary instance ip address"
}

variable "secondary_instance_ip" {
  description = "gcp secondary instance ip address"
}

variable "sap_vip_internal_address" {
  description = "sap virtual ip internal address"
}

variable "startup_script_1" {
  description = "Startup script for VM running SAP HANA HA."
}

variable "startup_script_2" {
  description = "Startup script for VM running SAP HANA HA."
}
