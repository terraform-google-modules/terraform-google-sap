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
  required_version = "~> 0.12.3"
}

data "google_compute_subnetwork" "subnet" {
  name    = "${var.subnetwork}"
  project = "${var.subnetwork_project != "" ? var.subnetwork_project : var.project_id}"
  region  = "${var.region}"
}

resource "google_compute_address" "gcp_master_ip" {
  project = "${var.project_id}"
  count   = "${var.instance_count_master}"
  name    = "gcp-master-${format("%01d", count.index + 2)}-ip"
  region  = "${var.region}"
}

resource "google_compute_disk" "pd_ssd_disk_0" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_0}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_1" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_1}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_2" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_2}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_3" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_3}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_4" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_4}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_5" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_5}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_6" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_6}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_7" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_7}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_ssd_disk_8" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-${var.device_8}"
  type    = "${var.disk_type}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_attached_disk" "pd_ssd_master_0" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_0}"
  disk        = "${google_compute_disk.pd_ssd_disk_0.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_1" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_1}"
  disk        = "${google_compute_disk.pd_ssd_disk_1.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_2" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_2}"
  disk        = "${google_compute_disk.pd_ssd_disk_2.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_3" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_3}"
  disk        = "${google_compute_disk.pd_ssd_disk_3.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_4" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_4}"
  disk        = "${google_compute_disk.pd_ssd_disk_4.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_5" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_5}"
  disk        = "${google_compute_disk.pd_ssd_disk_5.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_6" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_6}"
  disk        = "${google_compute_disk.pd_ssd_disk_6.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_7" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_7}"
  disk        = "${google_compute_disk.pd_ssd_disk_7.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_attached_disk" "pd_ssd_master_8" {
  project     = "${var.project_id}"
  device_name = "${var.instance_name}-${var.device_8}"
  disk        = "${google_compute_disk.pd_ssd_disk_8.self_link}"
  instance    = "${google_compute_instance.master.self_link}"
}

resource "google_compute_instance" "master" {
  project        = "${var.project_id}"
  count          = "${var.instance_count_master}"
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
      image = "projects/${var.linux_image_project}/global/images/family/${var.linux_image_family}"
      size  = "${var.boot_disk_size}"
      type  = "${var.boot_disk_type}"
    }
  }

  network_interface {
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.subnetwork_project != "" ? var.subnetwork_project : var.project_id}"

    dynamic "access_config" {
      for_each = [for i in [""] : i if var.public_ip]
      content {}

    }

  }

  metadata = {
    instanceName           = "${var.instance_name}"
    instanceType           = "${var.instance_type}"
    zone                   = "${var.zone}"
    post_deployment_script = "${var.post_deployment_script}"
    subnetwork             = "${var.subnetwork}"
    linuxImage             = "${var.linux_image_family}"
    linuxImageProject      = "${var.linux_image_project}"
    usrsapSize             = "${var.usr_sap_size}"
    sapmntSize             = "${var.sap_mnt_size}"
    swapSize               = "${var.swap_size}"
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
    startup-script         = "${var.startup_script}"
    publicIP               = "${var.public_ip}"
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}
