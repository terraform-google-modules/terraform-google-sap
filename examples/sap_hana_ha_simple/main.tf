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
# Version:    2.0.2022101419281665775728
# Build Hash: 5f4ef08feb4fed0e1eabc3bfc4b2d64d99001ae7
#
module "sap_hana_ha" {
  # hardcoding the module for testing only
  source = "../../modules/sap_hana_ha"

  # reference the module by its registry URL and version as such:
  # source = "terraform-google-modules/sap/google//modules/sap_hana_ha"
  # version = "0.5.0"

  project_id              = var.project_id
  machine_type            = "n1-standard-16"
  network                 = "default"
  subnetwork              = "default"
  linux_image             = "rhel-8-4-sap-ha"
  linux_image_project     = "rhel-sap-cloud"
  primary_instance_name   = "hana-ha-primary"
  primary_zone            = "us-east1-b"
  secondary_instance_name = "hana-ha-secondary"
  secondary_zone          = "us-east1-c"
}
