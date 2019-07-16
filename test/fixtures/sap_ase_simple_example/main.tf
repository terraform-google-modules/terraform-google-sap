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
  gcs_bucket_static_name = "${var.sap_ase_deployment_bucket}"
}

#TODO: Add creation of a network that's similar to app2

resource "google_storage_bucket" "deployment_bucket" {
  name          = "${local.gcs_bucket_name}"
  force_destroy = true
  location      = "${var.region}"
  storage_class = "REGIONAL"
  project       = "${var.project_id}"
}

data "template_file" "post_deployment_script" {
  template = "${file("${path.cwd}/files/templates/post_deployment_script.tpl")}"
}

data "template_file" "sap_ase" {
  template = "${file("${path.module}/files/sap_ase_startup.sh")}"
}

resource "google_storage_bucket_object" "post_deployment_script" {
  name    = "post_deployment_script.sh"
  content = "${data.template_file.post_deployment_script.rendered}"
  bucket  = "${google_storage_bucket.deployment_bucket.name}"
}

module "example" {
  source                 = "../../../examples/sap_ase_simple_example"
  subnetwork             = "${var.subnetwork}"
  linux_image_family     = "${var.linux_image_family}"
  linux_image_project    = "${var.linux_image_project}"
  instance_name          = "${var.instance_name}"
  instance_type          = "${var.instance_type}"
  zone                   = "${var.zone}"
  network_tags           = "${var.network_tags}"
  project_id             = "${var.project_id}"
  region                 = "${var.region}"
  service_account_email  = "${var.service_account_email}"
  boot_disk_size         = "${var.boot_disk_size}"
  boot_disk_type         = "${var.boot_disk_type}"
  disk_type              = "${var.disk_type}"
  autodelete_disk        = "true"
  pd_ssd_size            = "${var.pd_ssd_size}"
  usr_sap_size           = "${var.usr_sap_size}"
  sap_mnt_size           = "${var.sap_mnt_size}"
  swap_size              = "${var.swap_size}"
  aseSID                 = "${var.aseSID}"
  asesidSize             = "${var.asesidSize}"
  asediagSize            = "${var.asediagSize}"
  asesaptempSize         = "${var.asesaptempSize}"
  asesapdataSize         = "${var.asesapdataSize}"
  aselogSize             = "${var.aselogSize}"
  asebackupSize          = "${var.asebackupSize}"
  asesapdataSSD          = "${var.asesapdataSSD}"
  aselogSSD              = "${var.aselogSSD}"
  sap_ase_sid            = "${var.sap_ase_sid}"
  instance_count_master  = "${var.instance_count_master}"
  startup_script         = "${data.template_file.sap_ase.rendered}"
  post_deployment_script = "${google_storage_bucket.deployment_bucket.url}/${google_storage_bucket_object.post_deployment_script.name}"
}
