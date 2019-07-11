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

module "gcp_app_dr" {
  source                = "../../modules/sap_app_dr"
  subnetwork            = "${var.subnetwork}"
  instance_name         = "${var.instance_name}"
  instance_type         = "${var.instance_type}"
  project_id            = "${var.project_id}"
  region                = "${var.region}"
  service_account_email = "${var.service_account_email}"
  address_name          = "${var.address_name}"
  zone_1                = "${var.zone_1}"
  zone_2                = "${var.zone_2}"
  usc_class             = "${var.usc_class}"
  scs_user              = "${var.scs_user}"
  sap_user              = "${var.sap_user}"
  network_tags          = "${var.network_tags}"
  disk_type             = "${var.disk_type}"
  pd_ssd_size           = "${var.pd_ssd_size}"
  snapshot_name_0       = "${var.snapshot_name_0}"
  snapshot_name_1       = "${var.snapshot_name_1}"
  snapshot_name_2       = "${var.snapshot_name_2}"
  source_disk_0         = "${var.source_disk_0}"
  source_disk_1         = "${var.source_disk_1}"
  source_disk_2         = "${var.source_disk_2}"
}
