/**
 * Copyright 2022 Google LLC
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

variable "gcp_project_id" {
  type        = string
  description = "Project id where the instances will be created"
}
variable "deployment_name" {
  type        = string
  description = "deployment_name"
  default     = "my_s4"
}
variable "filestore_location" {
  type        = string
  description = "filestore_location"
  default     = "us-east1-b"
}
variable "region_name" {
  type        = string
  description = "region_name"
  default     = "us-east1"
}
variable "media_bucket_name" {
  type        = string
  description = "Project bucket with installation media available. This must be handled for HANA to be installed"
  default     = "custom-bucket"
}

variable "zone1_name" {
  type        = string
  description = "zone1_name"
  default     = "us-east1-c"
}
variable "zone2_name" {
  type        = string
  description = "zone1_name"
  default     = "us-east1-b"
}
