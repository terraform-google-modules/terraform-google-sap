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

module "sap_nw_ha" {
  source  = "terraform-google-modules/sap/google//modules/sap_nw_ha"
  version = "~> 1.0"

  project_id          = var.project_id
  machine_type        = "n1-highmem-32"
  network             = "default"
  subnetwork          = "default"
  linux_image         = "sles-15-sp2-sap"
  linux_image_project = "suse-sap-cloud"

  sap_primary_instance = "prd-nw1"
  sap_primary_zone     = "us-central1-b"

  sap_secondary_instance = "prd-nw2"
  sap_secondary_zone     = "us-central1-c"

  nfs_path = "1.2.3.4:/my_path"
  sap_sid  = "PE1"
}
