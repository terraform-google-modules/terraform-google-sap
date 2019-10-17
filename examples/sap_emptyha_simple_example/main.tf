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
  version     = "~> 2.6.0"
  credentials = "${file("credentials.json")}"
}

module "gcp_sap_emptyha" {
  source                   = "../../modules/sap_emptyha"
  post_deployment_script   = "${var.post_deployment_script}"
  subnetwork               = "${var.subnetwork}"
  linux_image_family       = "${var.linux_image_family}"
  linux_image_project      = "${var.linux_image_project}"
  instance_type            = "${var.instance_type}"
  network_tags             = "${var.network_tags}"
  project_id               = "${var.project_id}"
  region                   = "${var.region}"
  service_account_email    = "${var.service_account_email}"
  boot_disk_size           = "${var.boot_disk_size}"
  boot_disk_type           = "${var.boot_disk_type}"
  autodelete_disk          = "true"
  sap_deployment_debug     = "false"
  primary_instance_name    = "${var.primary_instance_name}"
  secondary_instance_name  = "${var.secondary_instance_name}"
  primary_zone             = "${var.primary_zone}"
  secondary_zone           = "${var.secondary_zone}"
  sap_vip                  = "${var.sap_vip}"
  sap_vip_secondary_range  = "${var.sap_vip_secondary_range}"
  public_ip                = "${var.public_ip}"
  sap_vip_internal_address = "${var.sap_vip_internal_address}"
  ip_cidr_range            = "${var.ip_cidr_range}"
}
