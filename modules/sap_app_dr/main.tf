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
terraform {
  required_version = "~> 0.11.0"
}

resource "google_compute_address" "gcp_sap_app_dr_ip" {
  project = "${var.project_id}"
  name    = "${var.address_name}"
  region  = "${var.region}"
}

# Creation of Snapshots from existing disk's in Primary zone

resource "google_compute_snapshot" "sap_app_dr_snapshot_0" {
  project     = "${var.project_id}"
  name        = "${var.snapshot_name_0}"
  source_disk = "${var.source_disk_0}"
  zone        = "${var.zone_1}"
}

resource "google_compute_snapshot" "sap_app_dr_snapshot_1" {
  project     = "${var.project_id}"
  name        = "${var.snapshot_name_1}"
  source_disk = "${var.source_disk_1}"
  zone        = "${var.zone_1}"
}

resource "google_compute_snapshot" "sap_app_dr_snapshot_2" {
  project     = "${var.project_id}"
  name        = "${var.snapshot_name_2}"
  source_disk = "${var.source_disk_2}"
  zone        = "${var.zone_1}"
}

# Creation of disk from snapshot's in Secondary Zone

resource "google_compute_disk" "sap_app_dr_disk_0" {
  project  = "${var.project_id}"
  name     = "${var.usc_class}-dr"
  type     = "${var.disk_type}"
  zone     = "${var.zone_2}"
  size     = "${var.pd_ssd_size}"
  snapshot = "${google_compute_snapshot.sap_app_dr_snapshot_0.name}"
}

resource "google_compute_disk" "sap_app_dr_disk_1" {
  project  = "${var.project_id}"
  name     = "${var.sap_user}-dr"
  type     = "${var.disk_type}"
  zone     = "${var.zone_2}"
  size     = "${var.pd_ssd_size}"
  snapshot = "${google_compute_snapshot.sap_app_dr_snapshot_1.name}"
}

resource "google_compute_disk" "sap_app_dr_disk_2" {
  project  = "${var.project_id}"
  name     = "${var.scs_user}-dr"
  type     = "${var.disk_type}"
  zone     = "${var.zone_2}"
  size     = "${var.pd_ssd_size}"
  snapshot = "${google_compute_snapshot.sap_app_dr_snapshot_2.name}"
}

# Creation of an instance from the above created disk's from snapshot in 2nd zone

resource "google_compute_instance" "gcp_sap_app_dr" {
  project                   = "${var.project_id}"
  name                      = "${var.instance_name}"
  machine_type              = "${var.instance_type}"
  zone                      = "${var.zone_2}"
  allow_stopping_for_update = true

  boot_disk {
    source = "${google_compute_disk.sap_app_dr_disk_0.self_link}"
  }

  attached_disk {
    source = "${google_compute_disk.sap_app_dr_disk_1.self_link}"
  }

  attached_disk {
    source = "${google_compute_disk.sap_app_dr_disk_2.self_link}"
  }

  network_interface {
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.project_id}"

    access_config = {
      nat_ip = "${element(google_compute_address.gcp_sap_app_dr_ip.*.address, count.index)}"
    }
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}
