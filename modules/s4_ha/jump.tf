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

resource "google_compute_disk" "sapdjump11" {
  image = "rhel-9-v20230203"
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.deployment_name}-jump-box"
  project = data.google_project.sap-project.project_id
  size    = 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_instance" "sapdjump11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdjump11.self_link
  }

  depends_on = [google_filestore_instance.sap_fstore_1]
  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = "e2-medium"
  metadata = {
    ssh-keys = ""
  }
  name = "${var.deployment_name}-jump-box"
  network_interface {
    access_config {
    }

    network = data.google_compute_network.sap-vpc.self_link
  }


  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service_account_jump.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-jump"]
  zone = var.zone1_name
}

resource "google_project_iam_member" "jump_sa_role_1" {
  member  = "serviceAccount:${google_service_account.service_account_jump.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_service_account" "service_account_jump" {
  account_id = "sap-jump-role-${var.deployment_name}"
  project    = data.google_project.sap-project.project_id
}

resource "google_service_account_iam_member" "jump_sa_user_of_app" {
  member             = "serviceAccount:${google_service_account.service_account_jump.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.service_account_app.name
}

resource "google_service_account_iam_member" "jump_sa_user_of_ascs" {
  member             = "serviceAccount:${google_service_account.service_account_jump.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.service_account_ascs.name
}

resource "google_service_account_iam_member" "jump_sa_user_of_db" {
  member             = "serviceAccount:${google_service_account.service_account_jump.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.service_account_db.name
}
