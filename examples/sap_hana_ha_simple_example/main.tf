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
  version = "~> 1.18.0"
  region  = "${var.region}"
}

module "gcp_sap_hana_ha" {
  source                     = "../../modules/sap_hana_ha"
  post_deployment_script     = "${var.post_deployment_script}"
  subnetwork                 = "${var.subnetwork}"
  linux_image_family         = "${var.linux_image_family}"
  linux_image_project        = "${var.linux_image_project}"
  instance_type              = "${var.instance_type}"
  network_tags               = "${var.network_tags}"
  project_id                 = "${var.project_id}"
  region                     = "${var.region}"
  service_account            = "${var.service_account}"
  boot_disk_size             = "${var.boot_disk_size}"
  boot_disk_type             = "${var.boot_disk_type}"
  autodelete_disk            = "${var.autodelete_disk}"
  pd_ssd_size                = "${var.pd_ssd_size}"
  pd_standard_size           = "${var.pd_standard_size}"
  sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
  sap_deployment_debug       = "${var.sap_deployment_debug}"
  post_deployment_script     = "${var.post_deployment_script}"
  sap_hana_sid               = "${var.sap_hana_sid}"
  sap_primary_instance       = "${var.sap_primary_instance}"
  sap_secondary_instance     = "${var.sap_secondary_instance}"
  sap_primary_zone           = "${var.sap_primary_zone}"
  sap_secondary_zone         = "${var.sap_secondary_zone}"
  sap_hana_instance_number   = "${var.sap_hana_instance_number}"
  sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
  sap_hana_system_password   = "${var.sap_hana_system_password}"
  sap_hana_sidadm_uid        = "${var.sap_hana_sidadm_uid}"
  sap_hana_sapsys_gid        = "${var.sap_hana_sapsys_gid}"
  sap_vip                    = "${var.sap_vip}"
  sap_vip_secondary_range    = "${var.sap_vip_secondary_range}"
  gcp_primary_instance_ip    = "${var.gcp_primary_instance_ip}"
  gcp_secondary_instance_ip  = "${var.gcp_secondary_instance_ip}"
  sap_vip_internal_address   = "${var.sap_vip_internal_address}"
  startup_script_1           = "${var.startup_script_1}"
  startup_script_2           = "${var.startup_script_2}"
  startup_script_custom      = "${var.startup_script_custom}"
}
