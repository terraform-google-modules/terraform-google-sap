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

#
# Version:    BUILD.VERSION
# Build Hash: BUILD.HASH
#
module "sap_hana" {
  # hardcoding the module for testing only
  source = "../../modules/sap_hana"

  # reference the module by its registry URL and version as such:
  # source = "terraform-google-modules/sap/google//modules/sap_hana"
  # version = "0.5.0"

  project_id          = var.project_id
  machine_type        = "n1-highmem-32"
  subnetwork          = "default"
  linux_image         = "rhel-8-4-sap-ha"
  linux_image_project = "rhel-sap-cloud"
  instance_name       = "hana-instance"
  zone                = "us-east1-b"
  sap_hana_sid        = "XYZ"
}
