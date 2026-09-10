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

module "sap_s4" {
  source  = "terraform-google-modules/sap/google//modules/s4"
  version = "~> 2.0"

  deployment_name     = "my_s4"
  gcp_project_id      = var.project_id
  filestore_location  = "us-east1-b"
  region_name         = "us-east1"
  media_bucket_name   = "private-bucket"
  zone1_name          = "us-east1-b"
}
