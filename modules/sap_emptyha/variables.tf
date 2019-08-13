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

variable "sap_deployment_debug" {
  description = "Debug flag for SAP HANA deployment."
}

variable "post_deployment_script" {
  description = "SAP post deployment script"
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
