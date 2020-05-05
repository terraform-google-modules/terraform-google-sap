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

module "sap_hana" {
  source        = "./sap_hana_python"
  instance-type = var.instance_type
}

resource "google_compute_disk" "gcp_sap_hana_sd_0" {
  project = var.project_id
  name    = "${var.disk_name_0}-${var.device_name_pd_ssd}"
  type    = var.disk_type_0
  zone    = var.zone
  size    = var.pd_ssd_size != "" ? var.pd_ssd_size : module.sap_hana.diskSize

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_disk" "gcp_sap_hana_sd_1" {
  project = var.project_id
  name    = "${var.disk_name_1}-${var.device_name_pd_hdd}"
  type    = var.disk_type_1
  zone    = var.zone
  size    = var.pd_hdd_size != "" ? var.pd_hdd_size : module.sap_hana.diskSize

  # Add the disk_encryption_key block only if a pd_kms_key was provided
  dynamic "disk_encryption_key" {
    for_each = var.pd_kms_key != null ? [""] : []
    content {
      kms_key_self_link = var.pd_kms_key
    }
  }
}

resource "google_compute_address" "gcp_sap_hana_ip" {
    count   = var.public_ip

    project = var.project_id
    name    = var.address_name
    region  = var.region
}

resource "google_compute_instance" "gcp_sap_hana" {
  project        = var.project_id
  name           = var.instance_name
  machine_type   = var.instance_type
  zone           = var.zone
  tags           = var.network_tags
  can_ip_forward = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    auto_delete       = var.autodelete_disk
    kms_key_self_link = var.pd_kms_key

    initialize_params {
      image = "projects/${var.linux_image_project}/global/images/family/${var.linux_image_family}"
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  attached_disk {
    source = google_compute_disk.gcp_sap_hana_sd_0.self_link
  }

  attached_disk {
    source = google_compute_disk.gcp_sap_hana_sd_1.self_link
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.project_id

    dynamic "access_config" {
      for_each = var.public_ip == 1 ? google_compute_address.gcp_sap_hana_ip : []
      content {
        nat_ip = access_config.value.address
      }
    }

  }

  metadata = {
    sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
    sap_deployment_debug       = var.sap_deployment_debug
    post_deployment_script     = var.post_deployment_script
    sap_hana_sid               = var.sap_hana_sid
    sap_hana_instance_number   = var.sap_hana_instance_number
    sap_hana_sidadm_password   = var.sap_hana_sidadm_password
    sap_hana_system_password   = var.sap_hana_system_password
    sap_hana_sidadm_uid        = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid        = var.sap_hana_sapsys_gid

    startup-script = var.startup_script
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
