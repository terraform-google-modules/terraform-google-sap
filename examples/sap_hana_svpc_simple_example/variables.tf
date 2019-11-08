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
  description = "The ID of the service project in which the resources will be deployed."
}

variable "subnetwork_project" {
  description = "The ID of the shared VPC host project in which the service project's will be deployed."
}

variable "zone" {
  description = "The zone that the service project instance should be created in."
}

variable "region" {
  description = "The region that the  service project instance should be created in."
}

variable "subnetwork" {
  description = "Compute Engine instance name"
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

}

variable "disk_name_1" {
  description = "Name of second disk."

}

variable "disk_type_0" {
  description = "The GCE data disk type. May be set to pd-ssd."
  default     = "pd-ssd"
}

variable "disk_type_1" {
  description = "The GCE data disk type. May be set to pd-standard (for PD HDD)."
  default     = "pd-standard"
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

variable "pd_hdd_size" {
  description = "Persistent disk size in GB."
  default     = ""
}

variable "device_name_pd_ssd" {
  description = "device name for ssd persistant disk"
  default     = "pdssd"
}

variable "device_name_pd_hdd" {
  description = "device name for standard persistant disk"
  default     = "backup"
}

variable "service_account_email" {
  description = "Email of service account to attach to the instance."
}

variable "network_tags" {
  type        = "list"
  description = "List of network tags to attach to the instance."
}

variable "sap_hana_deployment_bucket" {
  description = "SAP hana deployment bucket."
}

variable "sap_deployment_debug" {
  description = "Debug flag for SAP HANA deployment."
  default     = "false"
}

variable "post_deployment_script" {
  description = "SAP HANA post deployment script. Must be a gs:// or https:// link to the script."
  default     = ""
}

variable "PRIVATE_IP" {
  description = "Private Ip belonging to the Shared VPC Project."
  default     = ""
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

variable "public_ip" {
  description = "Determines whether a public IP address is added to your VM instance."
  default     = false
  type        = bool
}
