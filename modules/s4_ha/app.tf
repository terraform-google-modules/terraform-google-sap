# Copyright 2024 Google LLC
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

data "google_compute_subnetwork" "sap-subnet-app-1" {
  name    = var.subnet_name
  project = data.google_compute_network.sap-vpc.project
  region  = var.region_name
}

data "google_service_account" "service_account_app" {
  account_id = var.app_sa_email == "" ? google_service_account.service_account_app[0].email : var.app_sa_email
}

resource "google_compute_address" "sapdapp11-1" {
  address_type = "INTERNAL"
  count        = var.app_vms_multiplier
  name         = "${var.vm_prefix}app1${1 + (count.index * 2)}-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-app-1.self_link
}

resource "google_compute_address" "sapdapp12-1" {
  address_type = "INTERNAL"
  count        = var.app_vms_multiplier
  name         = "${var.vm_prefix}app1${2 + (count.index * 2)}-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-app-1.self_link
}

resource "google_compute_disk" "sapdapp11" {
  count = var.app_vms_multiplier
  image = var.sap_boot_disk_image_app == "" ? var.sap_boot_disk_image : var.sap_boot_disk_image_app
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = "${var.vm_prefix}app1${1 + (count.index * 2)}"
  project = data.google_project.sap-project.project_id
  size    = length(regexall("metal|c4-", var.app_machine_type)) > 0 ? 64 : 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = length(regexall("metal|c4-", var.app_machine_type)) > 0 ? "hyperdisk-balanced" : "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapdapp11_export_interfaces" {
  count = var.app_vms_multiplier
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${var.vm_prefix}app1${1 + (count.index * 2)}-export-interfaces"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.app_disk_type == "hyperdisk-extreme" ? max(10000, 2 * var.app_disk_export_interfaces_size) : null
  size             = var.app_disk_export_interfaces_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.app_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapdapp11_usr_sap" {
  count = var.app_vms_multiplier
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${var.vm_prefix}app1${1 + (count.index * 2)}-usr-sap"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.app_disk_type == "hyperdisk-extreme" ? max(10000, 2 * var.app_disk_usr_sap_size) : null
  size             = var.app_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.app_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapdapp12" {
  count = var.app_vms_multiplier
  image = var.sap_boot_disk_image_app == "" ? var.sap_boot_disk_image : var.sap_boot_disk_image_app
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = "${var.vm_prefix}app1${2 + (count.index * 2)}"
  project = data.google_project.sap-project.project_id
  size    = length(regexall("metal|c4-", var.app_machine_type)) > 0 ? 64 : 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = length(regexall("metal|c4-", var.app_machine_type)) > 0 ? "hyperdisk-balanced" : "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapdapp12_export_interfaces" {
  count = var.app_vms_multiplier
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${var.vm_prefix}app1${2 + (count.index * 2)}-export-interfaces"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.app_disk_type == "hyperdisk-extreme" ? max(10000, 2 * var.app_disk_export_interfaces_size) : null
  size             = var.app_disk_export_interfaces_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.app_disk_type
  zone = var.zone2_name
}

resource "google_compute_disk" "sapdapp12_usr_sap" {
  count = var.app_vms_multiplier
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${var.vm_prefix}app1${2 + (count.index * 2)}-usr-sap"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.app_disk_type == "hyperdisk-extreme" ? max(10000, 2 * var.app_disk_usr_sap_size) : null
  size             = var.app_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.app_disk_type
  zone = var.zone2_name
}

resource "google_compute_instance" "sapdapp11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdapp11_usr_sap[count.index].name
    source      = google_compute_disk.sapdapp11_usr_sap[count.index].self_link
  }
  attached_disk {
    device_name = google_compute_disk.sapdapp11_export_interfaces[count.index].name
    source      = google_compute_disk.sapdapp11_export_interfaces[count.index].self_link
  }
  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdapp11[count.index].self_link
  }
  count = var.app_vms_multiplier
  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }
  machine_type = var.app_machine_type
  metadata = {
    enable-oslogin = "FALSE"
    ssh-keys       = ""
  }
  min_cpu_platform = lookup(local.cpu_platform_map, var.app_machine_type, "Automatic")
  name             = "${var.vm_prefix}app1${1 + (count.index * 2)}"
  network_interface {
    dynamic "access_config" {
      content {
      }
      for_each = var.public_ip ? [1] : []
    }
    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapdapp11-1[count.index].address
    subnetwork = data.google_compute_subnetwork.sap-subnet-app-1.self_link
  }
  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = length(regexall("metal", var.app_machine_type)) > 0 ? "TERMINATE" : "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_app.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone1_name
}

resource "google_compute_instance" "sapdapp12" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdapp12_usr_sap[count.index].name
    source      = google_compute_disk.sapdapp12_usr_sap[count.index].self_link
  }
  attached_disk {
    device_name = google_compute_disk.sapdapp12_export_interfaces[count.index].name
    source      = google_compute_disk.sapdapp12_export_interfaces[count.index].self_link
  }
  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdapp12[count.index].self_link
  }
  count = var.app_vms_multiplier
  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }
  machine_type = var.app_machine_type
  metadata = {
    enable-oslogin = "FALSE"
    ssh-keys       = ""
  }
  min_cpu_platform = lookup(local.cpu_platform_map, var.app_machine_type, "Automatic")
  name             = "${var.vm_prefix}app1${2 + (count.index * 2)}"
  network_interface {
    dynamic "access_config" {
      content {
      }
      for_each = var.public_ip ? [1] : []
    }
    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapdapp12-1[count.index].address
    subnetwork = data.google_compute_subnetwork.sap-subnet-app-1.self_link
  }
  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = length(regexall("metal", var.app_machine_type)) > 0 ? "TERMINATE" : "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_app.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone2_name
}

resource "google_dns_record_set" "to_vm_sapdapp11" {
  count        = var.app_vms_multiplier
  managed_zone = data.google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}app1${1 + (count.index * 2)}.${data.google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas = [
    google_compute_instance.sapdapp11[count.index].network_interface[0].network_ip
  ]
  ttl  = 300
  type = "A"
}

resource "google_dns_record_set" "to_vm_sapdapp12" {
  count        = var.app_vms_multiplier
  managed_zone = data.google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}app1${2 + (count.index * 2)}.${data.google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas = [
    google_compute_instance.sapdapp12[count.index].network_interface[0].network_ip
  ]
  ttl  = 300
  type = "A"
}

resource "google_project_iam_member" "app_sa_role_1" {
  count   = var.app_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_app.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "app_sa_role_2" {
  count   = var.app_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_app.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "app_sa_role_3" {
  count   = var.app_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_app.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/logging.admin"
}

resource "google_project_iam_member" "app_sa_role_4" {
  count   = var.app_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_app.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.admin"
}

resource "google_project_iam_member" "app_sa_role_5" {
  count   = var.app_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_app.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.viewer"
}

resource "google_project_iam_member" "app_sa_role_6" {
  count   = var.app_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_app.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/workloadmanager.insightWriter"
}

resource "google_service_account" "service_account_app" {
  account_id = "${var.deployment_name}-app"
  count      = var.app_sa_email == "" ? 1 : 0
  project    = data.google_project.sap-project.project_id
}
