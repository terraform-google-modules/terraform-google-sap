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

data "google_compute_subnetwork" "sap-subnet-db-1" {
  name    = var.subnet_name
  project = data.google_project.sap-project.project_id
  region  = var.region_name
}

resource "google_compute_disk" "sapddb11" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}db11"
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

resource "google_compute_disk" "sapddb11_export_backup" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-export-backup"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_export_backup_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_data" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-data"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_data_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_log" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-log"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_log_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_restore" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-restore"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_restore_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-standard"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_shared" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-shared"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_shared_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_instance" "sapddb11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapddb11_usr_sap.name
    source      = google_compute_disk.sapddb11_usr_sap.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11_hana_data.name
    source      = google_compute_disk.sapddb11_hana_data.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11_hana_log.name
    source      = google_compute_disk.sapddb11_hana_log.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11_hana_shared.name
    source      = google_compute_disk.sapddb11_hana_shared.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11_export_backup.name
    source      = google_compute_disk.sapddb11_export_backup.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11_hana_restore.name
    source      = google_compute_disk.sapddb11_hana_restore.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapddb11.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.db_machine_type
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}db11"
  network_interface {
    access_config {
    }

    network    = data.google_compute_network.sap-vpc.self_link
    subnetwork = data.google_compute_subnetwork.sap-subnet-db-1.self_link
  }


  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service_account_db.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-db", "allow-health-checks"]
  zone = var.zone1_name
}

resource "google_dns_record_set" "global_master_db" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "db.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = ["${var.vm_prefix}db11.${google_dns_managed_zone.sap_zone.dns_name}"]
  ttl          = 60
  type         = "CNAME"
}

resource "google_dns_record_set" "to_vm_sapddb11" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}db11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_project_iam_member" "db_sa_role_1" {
  member  = "serviceAccount:${google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_service_account" "service_account_db" {
  account_id = "sap-db-role-${var.deployment_name}"
  project    = data.google_project.sap-project.project_id
}
