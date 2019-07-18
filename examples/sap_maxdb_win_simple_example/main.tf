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
  version = "~> 2.6.0"
  region  = "${var.region}"
}

module "gcp_sap_maxdb_win" {
  source                = "../../modules/sap_maxdb_win"
  project_id            = "${var.project_id}"
  subnetwork            = "${var.subnetwork}"
  windows_image_family  = "${var.windows_image_family}"
  windows_image_project = "${var.windows_image_project}"
  instance_name         = "${var.instance_name}"
  address_name          = "${var.address_name}"
  instance_type         = "${var.instance_type}"
  zone                  = "${var.zone}"
  network_tags          = "${var.network_tags}"
  region                = "${var.region}"
  service_account_email = "${var.service_account_email}"
  boot_disk_size        = "${var.boot_disk_size}"
  boot_disk_type        = "${var.boot_disk_type}"
  disk_type_0           = "${var.disk_type_0}"
  disk_type_1           = "${var.disk_type_1}"
  autodelete_disk       = "${var.autodelete_disk}"
  pd_ssd_size           = "${var.pd_ssd_size}"
  pd_hdd_size           = "${var.pd_hdd_size}"
  usr_sap_size          = "${var.usr_sap_size}"
  swap_size             = "${var.swap_size}"
  maxdbRootSize         = "${var.maxdbRootSize}"
  maxdbDataSize         = "${var.maxdbDataSize}"
  maxdbLogSize          = "${var.maxdbLogSize}"
  maxdbBackupSize       = "${var.maxdbBackupSize}"
  maxdbDataSSD          = "${var.maxdbDataSSD}"
  maxdbLogSSD           = "${var.maxdbLogSSD}"
  swapmntSize           = "${var.swapmntSize}"
  sap_maxdb_sid         = "${var.sap_maxdb_sid}"
}
