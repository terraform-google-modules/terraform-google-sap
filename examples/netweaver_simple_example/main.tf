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
}

module "gcp_netweaver" {
  source                 = "../../modules/netweaver"
  post_deployment_script = "${var.post_deployment_script}"
  subnetwork             = "${var.subnetwork}"
  linux_image_family     = "${var.linux_image_family}"
  linux_image_project    = "${var.linux_image_project}"
  autodelete_disk        = "true"
  public_ip              = "${var.public_ip}"
  sap_deployment_debug   = "${var.sap_deployment_debug}"
  usr_sap_size           = "${var.usr_sap_size}"
  sap_mnt_size           = "${var.sap_mnt_size}"
  swap_size              = "${var.swap_size}"
  instance_name          = "${var.instance_name}"
  instance_type          = "${var.instance_type}"
  region                 = "${var.region}"
  network_tags           = "${var.network_tags}"
  project_id             = "${var.project_id}"
  zone                   = "${var.zone}"
  service_account_email  = "${var.service_account_email}"
  boot_disk_size         = "${var.boot_disk_size}"
  boot_disk_type         = "${var.boot_disk_type}"
  disk_type              = "${var.disk_type}"
  startup_script         = "${var.startup_script}"
}
