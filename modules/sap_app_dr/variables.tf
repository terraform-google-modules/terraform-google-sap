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

variable "zone_1" {
  description = "The zone that the instance should be created in."
}

variable "zone_2" {
  description = "The zone that the instance should be created in."
}

variable "disk_type" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd."
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = ""
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

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in."
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags to attach to the instance."
}

variable "address_name" {
  description = "Name of static IP adress to add to the instance's access config."
}

variable "usc_class" {
  description = "First disk created from snapshot"
  type        = "string"
}

variable "sap_user" {
  description = "Second disk created from snapshot "
  type        = "string"
}

variable "scs_user" {
  description = "Third disk created from snapshot"
  type        = "string"
}

variable "source_disk_0" {
  description = "First Source Disk"
  type        = "string"
}

variable "source_disk_1" {
  description = "Second Source Disk"
  type        = "string"
}

variable "source_disk_2" {
  description = "Third Source Disk"
  type        = "string"
}

variable "snapshot_name_0" {
  description = "First Snapshot name"
  type        = "string"
}

variable "snapshot_name_1" {
  description = "Second Snapshot name"
  type        = "string"
}

variable "snapshot_name_2" {
  description = "Third Snapshot name"
  type        = "string"
}
