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

module "gcp_sap_hana_ha" {
  source                     = "../../modules/sap_hana_ha"
  subnetwork                 = var.subnetwork
  linux_image_family         = var.linux_image_family
  linux_image_project        = var.linux_image_project
  instance_type              = var.instance_type
  network_tags               = var.network_tags
  project_id                 = var.project_id
  region                     = var.region
  service_account_email      = var.service_account_email
  boot_disk_size             = var.boot_disk_size
  boot_disk_type             = var.boot_disk_type
  autodelete_disk            = "true"
  pd_ssd_size                = var.pd_ssd_size
  pd_hdd_size                = var.pd_hdd_size
  sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
  sap_deployment_debug       = "false"
  post_deployment_script     = var.post_deployment_script
  sap_hana_sid               = var.sap_hana_sid
  primary_instance_name      = var.primary_instance_name
  secondary_instance_name    = var.secondary_instance_name
  primary_zone               = var.primary_zone
  secondary_zone             = var.secondary_zone
  sap_hana_instance_number   = var.sap_hana_instance_number
  sap_hana_sidadm_password   = var.sap_hana_sidadm_password
  sap_hana_system_password   = var.sap_hana_system_password
  sap_hana_sidadm_uid        = 900
  sap_hana_sapsys_gid        = 900
  sap_vip                    = var.sap_vip
  sap_vip_secondary_range    = var.sap_vip_secondary_range
  primary_instance_ip        = var.primary_instance_ip
  secondary_instance_ip      = var.secondary_instance_ip
  sap_vip_internal_address   = var.sap_vip_internal_address
  startup_script_1           = file(var.startup_script_1)
  startup_script_2           = file(var.startup_script_2)
}
