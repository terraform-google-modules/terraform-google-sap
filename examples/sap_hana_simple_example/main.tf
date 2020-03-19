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

provider "google" {
  version = "~> 3.13.0"
  region  = var.region
}

module "gcp_sap_hana" {
  source                     = "../../modules/sap_hana"
  subnetwork                 = var.subnetwork
  linux_image_family         = var.linux_image_family
  linux_image_project        = var.linux_image_project
  instance_name              = var.instance_name
  instance_type              = var.instance_type
  project_id                 = var.project_id
  region                     = var.region
  zone                       = var.zone
  service_account_email      = var.service_account_email
  boot_disk_type             = var.boot_disk_type
  boot_disk_size             = var.boot_disk_size
  autodelete_disk            = "true"
  pd_ssd_size                = var.pd_ssd_size
  pd_hdd_size                = var.pd_hdd_size
  sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
  sap_deployment_debug       = "false"
  post_deployment_script     = var.post_deployment_script
  startup_script             = file(var.startup_script)
  sap_hana_sid               = var.sap_hana_sid
  sap_hana_instance_number   = var.sap_hana_instance_number
  sap_hana_sidadm_password   = var.sap_hana_sidadm_password
  sap_hana_system_password   = var.sap_hana_system_password
  network_tags               = var.network_tags
  sap_hana_sidadm_uid        = 900
  sap_hana_sapsys_gid        = 900
  address_name               = var.address_name
  pd_kms_key                 = google_kms_crypto_key.sap_hana_simple.self_link
}

# Create a KMS key to use as customer managed encryption key for the instance
# persistent disk. This is completely optional. If you do not need to manage
# your own keys, just remove this section and remove also the pd_kms_key
# parameter in the module declaration above.
resource "google_kms_key_ring" "sap_hana_simple" {
  project  = var.project_id
  name     = "sap-hana-simple-${random_id.this.hex}"
  location = var.region
}

resource "google_kms_crypto_key" "sap_hana_simple" {
  name     = "sap-hana-simple-${random_id.this.hex}"
  key_ring = google_kms_key_ring.sap_hana_simple.self_link
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_kms_crypto_key_iam_binding" "sap_hana_simple" {
  crypto_key_id = google_kms_crypto_key.sap_hana_simple.self_link

  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:service-${data.google_project.project.project_number}@compute-system.iam.gserviceaccount.com",
  ]
}

resource "random_id" "this" {
  byte_length = 2
}
