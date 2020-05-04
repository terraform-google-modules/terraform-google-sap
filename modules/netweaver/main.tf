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
  required_version = "~> 0.12.0"
}

locals {
  device_name_1 = "${var.instance_name}-${var.device_1}"
  device_name_2 = "${var.instance_name}-${var.device_2}"
  device_name_3 = "${var.instance_name}-${var.device_3}"
}

resource "google_compute_disk" "gcp_nw_pd_0" {
  project = var.project_id
  name    = "${var.instance_name}-nw-0"
  type    = var.disk_type
  zone    = var.zone
  count   = var.usr_sap_size > 0 ? 1 : 0
  size    = var.usr_sap_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_nw_pd_1" {
  project = var.project_id
  name    = "${var.instance_name}-nw-1"
  type    = var.disk_type
  zone    = var.zone
  count   = var.sap_mnt_size > 0 ? 1 : 0
  size    = var.sap_mnt_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_nw_pd_2" {
  project = var.project_id
  name    = "${var.instance_name}-nw-2"
  type    = var.disk_type
  zone    = var.zone
  count   = var.swap_size > 0 ? 1 : 0
  size    = var.swap_size

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_0" {
  project     = var.project_id
  count       = var.usr_sap_size > 0 ? 1 : 0
  device_name = local.device_name_1
  disk        = google_compute_disk.gcp_nw_pd_0[0].self_link
  instance    = google_compute_instance.gcp_nw.self_link
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_1" {
  project     = var.project_id
  count       = var.sap_mnt_size > 0 ? 1 : 0
  device_name = local.device_name_2
  disk        = google_compute_disk.gcp_nw_pd_1[0].self_link
  instance    = google_compute_instance.gcp_nw.self_link
}

resource "google_compute_attached_disk" "gcp_nw_attached_pd_2" {
  project     = var.project_id
  count       = var.swap_size > 0 ? 1 : 0
  device_name = local.device_name_3
  disk        = google_compute_disk.gcp_nw_pd_2[0].self_link
  instance    = google_compute_instance.gcp_nw.self_link
}

resource "google_compute_instance" "gcp_nw" {
  project                   = var.project_id
  name                      = var.instance_name
  machine_type              = var.instance_type
  zone                      = var.zone
  tags                      = var.network_tags
  allow_stopping_for_update = true
  can_ip_forward            = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    auto_delete       = var.autodelete_disk
    kms_key_self_link = var.pd_kms_key

    device_name = "${var.instance_name}-${var.device_0}"

    initialize_params {
      image = "projects/${var.linux_image_project}/global/images/family/${var.linux_image_family}"
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.project_id

    dynamic "access_config" {
      for_each = var.public_ip == 1 ? ["external_ip"] : []
      content {
        # assign an ephemeral external IP address
        nat_ip = null
      }
    }

  }

  metadata = {
    instanceName           = var.instance_name
    instanceType           = var.instance_type
    post_deployment_script = var.post_deployment_script
    subnetwork             = var.subnetwork
    usrsapSize             = var.usr_sap_size
    sapmntSize             = var.sap_mnt_size
    swapSize               = var.swap_size
    sap_deployment_debug   = var.sap_deployment_debug
    startup-script         = var.startup_script
    publicIP               = var.public_ip
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}
