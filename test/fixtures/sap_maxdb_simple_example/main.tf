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
  gcs_bucket_static_name = "${var.sap_maxdb_deployment_bucket}"
}

resource "google_storage_bucket" "deployment_bucket" {
  name          = "${local.gcs_bucket_name}"
  force_destroy = true
  location      = "${var.region}"
  storage_class = "REGIONAL"
  project       = "${var.project_id}"
}

data "template_file" "post_deployment_script" {
  template = "${file("${path.cwd}/files/templates/post_deployment_script.tpl")}"

  vars = {
    # sap_maxdb_sid needs to be lower case to work with `su -[SID]adm` command
    sap_maxdb_sid = "${lower(module.example.sap_maxdb_sid)}"
  }
}

data "template_file" "startup_sap_maxdb" {
  template = "${file("${path.module}/files/startup_sap_maxdb.sh")}"
}

resource "google_storage_bucket_object" "post_deployment_script" {
  name    = "post_deployment_script.sh"
  content = "${data.template_file.post_deployment_script.rendered}"
  bucket  = "${google_storage_bucket.deployment_bucket.name}"
}

module "example" {
  source                 = "../../../examples/sap_maxdb_simple_example"
  project_id             = "${var.project_id}"
  subnetwork             = "${var.subnetwork}"
  linux_image_family     = "${var.linux_image_family}"
  linux_image_project    = "${var.linux_image_project}"
  instance_name          = "${var.instance_name}"
  instance_type          = "${var.instance_type}"
  zone                   = "${var.zone}"
  network_tags           = "${var.network_tags}"
  region                 = "${var.region}"
  service_account_email  = "${var.service_account_email}"
  boot_disk_size         = "${var.boot_disk_size}"
  boot_disk_type         = "${var.boot_disk_type}"
  disk_type_0            = "${var.disk_type_0}"
  disk_type_1            = "${var.disk_type_1}"
  autodelete_disk        = "${var.autodelete_disk}"
  pd_ssd_size            = "${var.pd_ssd_size}"
  pd_standard_size       = "${var.pd_standard_size}"
  usr_sap_size           = "${var.usr_sap_size}"
  swap_size              = "${var.swap_size}"
  maxdbRootSize          = "${var.maxdbRootSize}"
  maxdbDataSize          = "${var.maxdbDataSize}"
  maxdbLogSize           = "${var.maxdbLogSize}"
  maxdbBackupSize        = "${var.maxdbBackupSize}"
  maxdbDataSSD           = "${var.maxdbDataSSD}"
  maxdbLogSSD            = "${var.maxdbLogSSD}"
  swapmntSize            = "${var.swapmntSize}"
  sap_maxdb_sid          = "${var.sap_maxdb_sid}"
  address_name           = "${var.address_name}"
  startup_script         = "${data.template_file.startup_sap_maxdb.rendered}"
  post_deployment_script = "${google_storage_bucket.deployment_bucket.url}/${google_storage_bucket_object.post_deployment_script.name}"
}
