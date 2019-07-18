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

resource "google_compute_address" "gcp_maxdb_win_ip" {
  project = "${var.project_id}"
  name    = "${var.address_name}"
  region  = "${var.region}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_0" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_0}"
  type    = "${var.disk_type_1}"
  zone    = "${var.zone}"
  size    = "${var.pd_hdd_size}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_1" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_1}"
  type    = "${var.disk_type_1}"
  zone    = "${var.zone}"
  size    = "${var.pd_hdd_size}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_2" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_2}"
  type    = "${var.disk_type_1}"
  zone    = "${var.zone}"
  size    = "${var.pd_hdd_size}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_3" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_3}"
  type    = "${var.disk_type_1}"
  zone    = "${var.zone}"
  size    = "${var.pd_hdd_size}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_4" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_4}"
  type    = "${var.disk_type_0}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_5" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_5}"
  type    = "${var.disk_type_0}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "gcp_maxdb_win_sd_6" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_6}"
  type    = "${var.disk_type_0}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_0" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_0}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_0.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_1" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_1}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_1.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_2" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_2}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_2.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_3" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_3}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_3.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_4" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_4}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_4.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_5" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_5}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_5.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_attached_disk" "gcp_maxdb_win_attached_sd_6" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_6}"
  disk        = "${google_compute_disk.gcp_maxdb_win_sd_6.self_link}"
  instance    = "${google_compute_instance.gcp_maxdb_win.self_link}"
}

resource "google_compute_instance" "gcp_maxdb_win" {
  project        = "${var.project_id}"
  name           = "${var.instance_name}"
  machine_type   = "${var.instance_type}"
  zone           = "${var.zone}"
  tags           = "${var.network_tags}"
  can_ip_forward = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    auto_delete = "${var.autodelete_disk}"

    device_name = "${var.instance_name}-${var.device}"

    initialize_params {
      image = "projects/${var.windows_image_project}/global/images/family/${var.windows_image_family}"
      size  = "${var.boot_disk_size}"
      type  = "${var.boot_disk_type}"
    }
  }

  network_interface {
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.project_id}"

    access_config {
      nat_ip = "${element(google_compute_address.gcp_maxdb_win_ip.*.address, count.index)}"
    }
  }

  metadata {
    instanceName           = "${var.instance_name}"
    instanceType           = "${var.instance_type}"
    zone                   = "${var.zone}"
    post_deployment_script = "${var.post_deployment_script}"
    windowsImage           = "${var.windows_image_family}"
    windowsImageProject    = "${var.windows_image_project}"
    subnetwork             = "${var.subnetwork}"
    usrsapSize             = "${var.usr_sap_size}"
    swapSize               = "${var.swap_size}"
    maxdbRootSize          = "${var.maxdbRootSize}"
    maxdbDataSize          = "${var.maxdbDataSize}"
    maxdbLogSize           = "${var.maxdbLogSize}"
    maxdbBackupSize        = "${var.maxdbBackupSize}"
    maxdbDataSSD           = "${var.maxdbDataSSD}"
    maxdbLogSSD            = "${var.maxdbLogSSD}"
    swapmntSize            = "${var.swapmntSize}"
    sap_maxdb_sid          = "${var.sap_maxdb_sid}"
  }

  metadata {
    windows-startup-script-url = "https://storage.googleapis.com/sapdeploy/dm-templates/sap_maxdb-win/startup.ps1"
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}
