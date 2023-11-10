# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_storage_bucket" "configuration" {
  count                       = var.configuration_bucket_name == "" ? 1 : 0
  force_destroy               = true
  location                    = "US"
  name                        = "${var.gcp_project_id}-${var.deployment_name}-configuration"
  project                     = data.google_project.sap-project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}
