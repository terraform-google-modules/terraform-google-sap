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
  gcs_bucket_name        = "post-deployment-bucket-${random_id.random_suffix.hex}"
  gcs_bucket_static_name = var.nw_deployment_bucket
}


resource "google_storage_bucket" "deployment_bucket" {
  name          = local.gcs_bucket_name
  force_destroy = true
  location      = var.region
  storage_class = "REGIONAL"
  project       = var.project_id
}

data "template_file" "post_deployment_script" {
  template = file("${path.module}/files/templates/post_deployment_script.tpl")
}

data "template_file" "netweaver" {
  template = file("${path.module}/files/netweaver_startup.sh")
}

resource "google_storage_bucket_object" "post_deployment_script" {
  name    = "post_deployment_script.sh"
  content = data.template_file.post_deployment_script.rendered
  bucket  = google_storage_bucket.deployment_bucket.name
}

module "example" {
  source                 = "../../../examples/netweaver_simple_example"
  subnetwork             = var.subnetwork
  linux_image_family     = var.linux_image_family
  linux_image_project    = var.linux_image_project
  public_ip              = var.public_ip
  sap_deployment_debug   = var.sap_deployment_debug
  usr_sap_size           = var.usr_sap_size
  sap_mnt_size           = var.sap_mnt_size
  swap_size              = var.swap_size
  pd_kms_key             = var.disks_cmek
  instance_name          = var.instance_name
  instance_type          = var.instance_type
  network_tags           = var.network_tags
  project_id             = var.project_id
  region                 = var.region
  zone                   = var.zone
  service_account_email  = var.service_account_email
  boot_disk_size         = var.boot_disk_size
  boot_disk_type         = var.boot_disk_type
  disk_type              = var.disk_type
  autodelete_disk        = var.autodelete_disk
  startup_script         = data.template_file.netweaver.rendered
  post_deployment_script = "${google_storage_bucket.deployment_bucket.url}/${google_storage_bucket_object.post_deployment_script.name}"
}
