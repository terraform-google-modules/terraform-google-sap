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
  # source = "terraform-google-modules/sap/google"
  # version = "0.5.0"

  project_id                      = var.project_id
  machine_type                    = "n1-highmem-32"
  network                         = "default"
  subnetwork                      = "default"
  linux_image                     = "rhel-8-4-sap-ha"
  linux_image_project             = "rhel-sap-cloud"
  primary_instance_name           = "hana-ha-primary"
  primary_zone                    = "us-east1-b"
  secondary_instance_name         = "hana-ha-secondary"
  secondary_zone                  = "us-east1-c"
  sap_hana_deployment_bucket      = var.sap_hana_deployment_bucket
  sap_hana_sid                    = var.sap_hana_sid
  sap_hana_instance_number        = var.sap_hana_instance_number
  sap_hana_sidadm_password        = var.sap_hana_sidadm_password
  sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
  sap_hana_system_password        = var.sap_hana_system_password
  sap_hana_system_password_secret = var.sap_hana_system_password_secret
  sap_hana_backup_size            = var.sap_hana_backup_size
  sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
  sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
  sap_vip                         = var.sap_vip
  primary_instance_group_name     = var.primary_instance_group_name
  secondary_instance_group_name   = var.secondary_instance_group_name
  loadbalancer_name               = var.loadbalancer_name
  network_tags                    = var.network_tags
  public_ip                       = var.public_ip
  service_account                 = var.service_account
  primary_reservation_name        = var.primary_reservation_name
  secondary_reservation_name      = var.secondary_reservation_name
}
