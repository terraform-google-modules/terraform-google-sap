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
  gcs_bucket_name = "deployment-bucket-${random_id.random_suffix.hex}"

  # TODO: Add requirements of downloading sotware in README.md of module.
  #gcs_bucket_static_name = "deployment-bucket-static/hana20sps03"
  gcs_bucket_static_name = "hana-gcp-20/hana20sps03"
}

#TODO: Add creation of a network that's similar to app2 
resource "google_storage_bucket" "deployment_bucket" {
  name          = "${local.gcs_bucket_name}"
  force_destroy = true
  location      = "${var.region}"
  storage_class = "REGIONAL"
  project       = "${var.project_id}"
}

module "example" {
  source = "../../../examples/simple_example"
  project_id                = "${var.project_id}"
  service_account        = "${var.service_account}"
  instance_type = "${var.instance_type}"
  sap_hana_deployment_bucket = "${local.gcs_bucket_static_name}"
  subnetwork = "default"
  network_tags=["foo"]
}
