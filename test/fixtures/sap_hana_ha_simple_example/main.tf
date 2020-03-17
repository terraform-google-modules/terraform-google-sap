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

resource "random_id" "random_suffix" {
  byte_length = 4
}

locals {
  gcs_bucket_name = "post-deployment-bucket-${random_id.random_suffix.hex}"

  gcs_bucket_static_name = var.sap_hana_deployment_bucket
}

#TODO: Add creation of a network that's similar to app2
resource "google_storage_bucket" "deployment_bucket" {
  name          = local.gcs_bucket_name
  force_destroy = true
  location      = var.region
  storage_class = "REGIONAL"
  project       = var.project_id
}

data "template_file" "post_deployment_script" {
  template = file("${path.cwd}/files/post_deployment_script.tpl")

  vars = {
    # sap_hana_id (SID) needs to be lower case to work with `su -[SID]adm` command
    sap_hana_sid = lower(module.example.sap_hana_sid)
  }
}


resource "google_storage_bucket_object" "post_deployment_script" {
  name    = "post_deployment_script.sh"
  content = data.template_file.post_deployment_script.rendered
  bucket  = google_storage_bucket.deployment_bucket.name
}

module "example" {
  source                     = "../../../examples/sap_hana_ha_simple_example"
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
  pd_hdd_size                = var.pd_hdd_size
  pd_ssd_size                = var.pd_ssd_size
  primary_instance_name      = var.primary_instance_name
  secondary_instance_name    = var.secondary_instance_name
  primary_zone               = var.primary_zone
  secondary_zone             = var.secondary_zone
  sap_hana_sid               = var.sap_hana_sid
  sap_hana_sidadm_uid        = 900
  sap_hana_sapsys_gid        = 900
  sap_hana_instance_number   = var.sap_hana_instance_number
  sap_hana_sidadm_password   = var.sap_hana_sidadm_password
  sap_hana_system_password   = var.sap_hana_system_password
  sap_vip                    = var.sap_vip
  sap_vip_secondary_range    = var.sap_vip_secondary_range
  primary_instance_ip        = var.primary_instance_ip
  secondary_instance_ip      = var.secondary_instance_ip
  sap_vip_internal_address   = var.sap_vip_internal_address
  sap_hana_deployment_bucket = local.gcs_bucket_static_name
  startup_script_1           = "../../../modules/sap_hana_ha/files/startup.sh"
  startup_script_2           = "../../../modules/sap_hana_ha/files/startup_secondary.sh"
  post_deployment_script     = "${google_storage_bucket.deployment_bucket.url}/${google_storage_bucket_object.post_deployment_script.name}"
}
