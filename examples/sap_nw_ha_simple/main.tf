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

  project_id              = var.project_id
  machine_type            = "n1-standard-16"
  network                 = "default"
  subnetwork              = "default"
  linux_image             = "rhel-8-4-sap-ha"
  linux_image_project     = "rhel-sap-cloud"
  sap_primary_instance    = "hana-instance"
  sap_secondary_instance  = "hana-instance"
  sap_primary_zone        = "us-east1-b"
  sap_secondary_zone      = "us-east1-c"
  sap_sid                 = "XYZ"
  nfs_path                = "${google_filestore_instance.example.networks[0].ip_addresses[0]}:/${google_filestore_instance.example.file_shares[0].name}"
}

resource "google_filestore_instance" "example" {
  name     = "example-instance"
  location = "us-central1-b"
  tier     = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
