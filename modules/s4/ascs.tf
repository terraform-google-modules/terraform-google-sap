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

data "google_compute_subnetwork" "sap-subnet-ascs-1" {
  name    = var.subnet_name
  project = data.google_project.sap-project.project_id
  region  = var.region_name
}

resource "google_compute_address" "sapdascs11-1" {
  address_type = "INTERNAL"
  name         = "${var.vm_prefix}ascs11-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
}

resource "google_compute_disk" "sapdascs11" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}ascs11"
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

resource "google_compute_disk" "sapdascs11_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}ascs11-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.ascs_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = var.disk_type == "hyperdisk-extreme" ? "pd-ssd" : var.disk_type
  zone = var.zone1_name
}

resource "google_compute_instance" "sapdascs11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdascs11_usr_sap.name
    source      = google_compute_disk.sapdascs11_usr_sap.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdascs11.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.ascs_machine_type
  metadata = {
    VmDnsSetting = "ZonalPreferred"
    ssh-keys     = ""
  }
  min_cpu_platform = lookup(local.cpu_platform_map, var.ascs_machine_type, "Automatic")
  name             = "${var.vm_prefix}ascs11"
  network_interface {
    dynamic "access_config" {
      content {
      }

      for_each = var.public_ip ? [1] : []
    }

    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapdascs11-1.address
    subnetwork = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
  }


  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service_account_ascs.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["allow-health-checks", "${var.deployment_name}-s4-comms"]
  zone = var.zone1_name
}

resource "google_dns_record_set" "ascs_alidascs11" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "alidascs11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_dns_record_set.to_vm_sapdascs11.name]
  ttl          = 300
  type         = "CNAME"
}

resource "google_dns_record_set" "to_vm_sapdascs11" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}ascs11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_project_iam_member" "ascs_sa_role_1" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_project_iam_member" "ascs_sa_role_2" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "ascs_sa_role_3" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "ascs_sa_role_4" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/logging.admin"
}

resource "google_project_iam_member" "ascs_sa_role_5" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.admin"
}

resource "google_project_iam_member" "ascs_sa_role_6" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.viewer"
}

resource "google_service_account" "service_account_ascs" {
  account_id = "${var.deployment_name}-ascs"
  project    = data.google_project.sap-project.project_id
}
