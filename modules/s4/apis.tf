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

resource "google_project_service" "service_cloudresourcemanager_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "service_compute_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "compute.googleapis.com"
}

resource "google_project_service" "service_dns_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "dns.googleapis.com"
}

resource "google_project_service" "service_file_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "file.googleapis.com"
}

resource "google_project_service" "service_iam_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "iam.googleapis.com"
}

resource "google_project_service" "service_iamcredentials_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "iamcredentials.googleapis.com"
}

resource "google_project_service" "service_secretmanager_googleapis_com" {
  disable_on_destroy = false
  project            = data.google_project.sap-project.project_id
  service            = "secretmanager.googleapis.com"
}
