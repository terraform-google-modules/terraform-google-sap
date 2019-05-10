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
  description = "Project name to deploy the resources"
}

variable "service_account_email" {
  description = "Service to run the terraform"
}

variable "instance_type" {
  description = "Compute Engine instance Type"

  # Should add minimal instance type here if possible.
}

variable "region" {
  description = "Region where to deploy resources"
  default     = "us-central1"
}

variable "instance_name" {
  description = "Compute Engine instance name"
  default     = "sap-hana-simple-example"
}


variable "linux_image_family" {
  description = "Compute Engine image name"
}

variable "linux_image_project" {
  description = "Project name containing the linux image"
}

variable "disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD."
}

variable "boot_disk_size" {
  description = "Root disk size in GB"
  # TODO: Make smaller boot disk size if possible.
  default = 64
}

variable "boot_disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD."
  default     = "pd-ssd"
}

variable "pd_ssd_size" {
  description = "Persistent disk size in GB"
  default     = 450
}
