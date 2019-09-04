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
  gcs_bucket_static_name = "${var.sap_hana_deployment_bucket}"
}

resource "google_storage_bucket" "deployment_bucket" {
  name          = "${local.gcs_bucket_name}"
  force_destroy = true
  location      = "${var.region}"
  storage_class = "REGIONAL"
  project       = "${var.project_id}"
}

data "template_file" "post_deployment_script" {
  template = "${file("${path.cwd}/files/post_deployment_script.tpl")}"

  vars = {
    # sap_hana_sid needs to be lower case to work with `su -[SID]adm` command
    sap_hana_sid = "${lower(module.example.sap_hana_sid)}"
  }
}

resource "google_storage_bucket_object" "post_deployment_script" {
  name    = "post_deployment_script.sh"
  content = "${data.template_file.post_deployment_script.rendered}"
  bucket  = "${google_storage_bucket.deployment_bucket.name}"
}

module "example" {
  source                     = "../../../examples/sap_hana_simple_example"
  project_id                 = "${var.project_id}"
  service_account_email      = "${var.service_account_email}"
  instance_type              = "${var.instance_type}"
  linux_image_family         = "${var.linux_image_family}"
  linux_image_project        = "${var.linux_image_project}"
  region                     = "${var.region}"
  zone                       = "${var.zone}"
  instance_name              = "${var.instance_name}"
  address_name               = "${var.address_name}"
  network_tags               = "${var.network_tags}"
  boot_disk_type             = "${var.boot_disk_type}"
  boot_disk_size             = "${var.boot_disk_size}"
  pd_ssd_size                = "${var.pd_ssd_size}"
  pd_hdd_size                = "${var.pd_hdd_size}"
  sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
  sap_hana_system_password   = "${var.sap_hana_system_password}"
  sap_hana_sid               = "${var.sap_hana_sid}"
  sap_hana_instance_number   = "${var.sap_hana_instance_number}"
  subnetwork                 = "${var.subnetwork}"
  startup_script             = "../../../modules/sap_hana/files/startup.sh"
  sap_hana_deployment_bucket = "${local.gcs_bucket_static_name}"
  post_deployment_script     = "${google_storage_bucket.deployment_bucket.url}/${google_storage_bucket_object.post_deployment_script.name}"
}
