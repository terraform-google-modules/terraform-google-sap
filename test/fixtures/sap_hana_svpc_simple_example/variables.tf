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
  type        = string
  description = "The ID of the service project in which the resources will be deployed."
}

variable "subnetwork_project" {
  type        = string
  description = "The ID of the host project in which the  network resources will be deployed."
}

variable "service_account_email" {
  type        = string
  description = "Email of service account to attach to the instance."
}

variable "instance_type" {
  type        = string
  description = "The GCE instance/machine type."
}

variable "region" {
  type        = string
  description = "Region where to deploy resources"
}

variable "zone" {
  type        = string
  description = "The zone that the instance should be created in."
}

variable "instance_name" {
  type        = string
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
}

variable "linux_image_family" {
  type        = string
  description = "Compute Engine image name"
}

variable "linux_image_project" {
  type        = string
  description = "Project name containing the linux image"
}

variable "disk_name_0" {
  type        = string
  description = "Name of first disk."
}

variable "disk_name_1" {
  type        = string
  description = "Name of second disk."
}

variable "boot_disk_size" {
  type        = string
  description = "Root disk size in GB"
}

variable "boot_disk_type" {
  type        = string
  description = "The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "pd_ssd_size" {
  type        = string
  description = "Persistent disk size in GB"
  default     = ""
}

variable "pd_hdd_size" {
  type        = string
  description = "Persistent disk size in GB."
  default     = ""
}

variable "subnetwork" {
  type        = string
  description = "Compute Engine instance name"
}

variable "sap_hana_sidadm_password" {
  type        = string
  description = "SAP HANA System Identifier Admin password"
}

variable "sap_hana_system_password" {
  type        = string
  description = "SAP HANA system password"
}

variable "sap_hana_deployment_bucket" {
  type        = string
  description = "SAP hana deployment bucket."
}

variable "sap_hana_sid" {
  type        = string
  description = "SAP HANA System Identifier"
}

variable "sap_hana_instance_number" {
  type        = string
  description = "SAP HANA instance number"
}

variable "address_name" {
  type        = string
  description = "Name of static IP adress to add to the instance's access config."
}

variable "network_tags" {
  type        = list(string)
  description = "List of network tags to attach to the instance."
}
