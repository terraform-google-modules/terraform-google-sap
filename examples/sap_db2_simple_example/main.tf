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

module "gcp_sap_db2" {
  source                = "../../modules/sap_db2"
  subnetwork            = "${var.subnetwork}"
  linux_image_family    = "${var.linux_image_family}"
  linux_image_project   = "${var.linux_image_project}"
  instance_name         = "${var.instance_name}"
  instance_type         = "${var.instance_type}"
  zone                  = "${var.zone}"
  network_tags          = "${var.network_tags}"
  project_id            = "${var.project_id}"
  region                = "${var.region}"
  service_account_email = "${var.service_account_email}"
  boot_disk_size        = "${var.boot_disk_size}"
  boot_disk_type        = "${var.boot_disk_type}"
  disk_type             = "${var.disk_type}"
  autodelete_disk       = "true"
  pd_standard_size      = "${var.pd_standard_size}"
  usr_sap_size          = "${var.usr_sap_size}"
  swap_mnt_size         = "${var.swap_mnt_size}"
  swap_size             = "${var.swap_size}"
  db2_sid               = "${var.db2_sid}"
  db2sid_size           = "${var.db2sid_size}"
  db2home_size          = "${var.db2home_size}"
  db2dump_size          = "${var.db2dump_size}"
  db2saptmp_size        = "${var.db2saptmp_size}"
  db2log_size           = "${var.db2log_size}"
  db2log_ssd            = "${var.db2log_ssd}"
  db2sapdata_size       = "${var.db2sapdata_size}"
  db2sapdata_ssd        = "${var.db2sapdata_ssd}"
  db2backup_size        = "${var.db2backup_size}"
  startup_script        = "${var.startup_script}"
  public_ip             = "${var.public_ip}"
}
