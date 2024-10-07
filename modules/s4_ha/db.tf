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

data "google_compute_subnetwork" "sap-subnet-db-1" {
  name    = var.subnet_name
  project = data.google_compute_network.sap-vpc.project
  region  = var.region_name
}

data "google_service_account" "service_account_db" {
  account_id = var.db_sa_email == "" ? google_service_account.service_account_db[0].email : var.db_sa_email
}

locals {
  hdx_hana_config = var.db_log_disk_type == "hyperdisk-extreme" ? true : false
}

resource "google_compute_address" "sapddb11-1" {
  address_type = "INTERNAL"
  name         = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-db-1.self_link
}

resource "google_compute_address" "sapddb12-1" {
  address_type = "INTERNAL"
  name         = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-db-1.self_link
}

resource "google_compute_disk" "sapddb11" {
  image = var.sap_boot_disk_image_db == "" ? var.sap_boot_disk_image : var.sap_boot_disk_image_db
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"
  project = data.google_project.sap-project.project_id
  size    = length(regexall("metal|c4-", var.db_machine_type)) > 0 ? 64 : 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = length(regexall("metal|c4-", var.db_machine_type)) > 0 ? "hyperdisk-balanced" : "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_data" {
  count = var.number_data_disks
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-hana-data-${count.index}"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_data_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_hana_data_size"] != 0 ? var.disk_size_map["db_disk_hana_data_size"] :  var.db_disk_hana_data_size)) / var.number_data_disks : null
  size             = (var.disk_size_map["db_disk_hana_data_size"] != 0 ? var.disk_size_map["db_disk_hana_data_size"] :  var.db_disk_hana_data_size) / var.number_data_disks
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_data_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_log" {
  count = var.number_log_disks
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-hana-log-${count.index}"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_log_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_hana_log_size"] != 0 ? var.disk_size_map["db_disk_hana_log_size"] :  var.db_disk_hana_log_size)) / var.number_log_disks : null
  size             = (var.disk_size_map["db_disk_hana_log_size"] != 0 ? var.disk_size_map["db_disk_hana_log_size"] :  var.db_disk_hana_log_size) / var.number_log_disks
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_log_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hana_shared" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-hana-shared"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_hana_shared_size"] != 0 ? var.disk_size_map["db_disk_hana_shared_size"] :  var.db_disk_hana_shared_size)) : null
  size             = (var.disk_size_map["db_disk_hana_shared_size"] != 0 ? var.disk_size_map["db_disk_hana_shared_size"] :  var.db_disk_hana_shared_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_hanabackup" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-hanabackup"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_backup_size"] != 0 ? var.disk_size_map["db_disk_backup_size"] :  var.db_disk_backup_size)) : null
  size             = (var.disk_size_map["db_disk_backup_size"] != 0 ? var.disk_size_map["db_disk_backup_size"] :  var.db_disk_backup_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb11_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-usr-sap"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_usr_sap_size"] != 0 ? var.disk_size_map["db_disk_usr_sap_size"] :  var.db_disk_usr_sap_size)) : null
  size             = (var.disk_size_map["db_disk_usr_sap_size"] != 0 ? var.disk_size_map["db_disk_usr_sap_size"] :  var.db_disk_usr_sap_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapddb12" {
  image = var.sap_boot_disk_image_db == "" ? var.sap_boot_disk_image : var.sap_boot_disk_image_db
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"
  project = data.google_project.sap-project.project_id
  size    = length(regexall("metal|c4-", var.db_machine_type)) > 0 ? 64 : 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = length(regexall("metal|c4-", var.db_machine_type)) > 0 ? "hyperdisk-balanced" : "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_data" {
  count = var.number_data_disks
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-hana-data-${count.index}"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_data_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_hana_data_size"] != 0 ? var.disk_size_map["db_disk_hana_data_size"] :  var.db_disk_hana_data_size)) / var.number_data_disks : null
  size             = (var.disk_size_map["db_disk_hana_data_size"] != 0 ? var.disk_size_map["db_disk_hana_data_size"] :  var.db_disk_hana_data_size) / var.number_data_disks
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_data_disk_type
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_log" {
  count = var.number_log_disks
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-hana-log-${count.index}"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_log_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_hana_log_size"] != 0 ? var.disk_size_map["db_disk_hana_log_size"] :  var.db_disk_hana_log_size)) / var.number_log_disks : null
  size             = (var.disk_size_map["db_disk_hana_log_size"] != 0 ? var.disk_size_map["db_disk_hana_log_size"] :  var.db_disk_hana_log_size) / var.number_log_disks
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_log_disk_type
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_shared" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-hana-shared"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_hana_shared_size"] != 0 ? var.disk_size_map["db_disk_hana_shared_size"] :  var.db_disk_hana_shared_size)) : null
  size             = (var.disk_size_map["db_disk_hana_shared_size"] != 0 ? var.disk_size_map["db_disk_hana_shared_size"] :  var.db_disk_hana_shared_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_disk_type
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hanabackup" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-hanabackup"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_backup_size"] != 0 ? var.disk_size_map["db_disk_backup_size"] :  var.db_disk_backup_size)) : null
  size             = (var.disk_size_map["db_disk_backup_size"] != 0 ? var.disk_size_map["db_disk_backup_size"] :  var.db_disk_backup_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_disk_type
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-usr-sap"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.db_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (var.disk_size_map["db_disk_usr_sap_size"] != 0 ? var.disk_size_map["db_disk_usr_sap_size"] :  var.db_disk_usr_sap_size)) : null
  size             = (var.disk_size_map["db_disk_usr_sap_size"] != 0 ? var.disk_size_map["db_disk_usr_sap_size"] :  var.db_disk_usr_sap_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.db_disk_type
  zone = var.zone2_name
}

resource "google_compute_firewall" "ilb_firewall_db" {
  allow {
    ports    = [var.db_ilb_healthcheck_port]
    protocol = "tcp"
  }
  description   = "Google-FW-LB"
  name          = "ilb-firewall-db-${var.deployment_name}"
  network       = data.google_compute_network.sap-vpc.self_link
  project       = data.google_compute_network.sap-vpc.project
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = google_compute_instance.sapddb11.tags
}

resource "google_compute_forwarding_rule" "db_forwarding_rule" {
  all_ports             = true
  allow_global_access   = true
  backend_service       = google_compute_region_backend_service.db_service.self_link
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  name                  = "${var.deployment_name}-db-forwarding-rule"
  network               = data.google_compute_network.sap-vpc.self_link
  project               = data.google_project.sap-project.project_id
  region                = var.region_name
  subnetwork            = data.google_compute_subnetwork.sap-subnet-db-1.self_link
}

resource "google_compute_health_check" "db_service_health_check" {
  check_interval_sec = 10
  name               = "${var.deployment_name}-db-service-health-check"
  project            = data.google_project.sap-project.project_id
  tcp_health_check {
    port = var.db_ilb_healthcheck_port
  }
  timeout_sec = 10
}

resource "google_compute_instance" "sapddb11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapddb11_usr_sap.name
    source      = google_compute_disk.sapddb11_usr_sap.self_link
  }
  dynamic "attached_disk" {
    content {
      device_name = attached_disk.value.name
      source      = attached_disk.value.self_link
    }
    for_each = google_compute_disk.sapddb11_hana_data[*]
  }
  dynamic "attached_disk" {
    content {
      device_name = attached_disk.value.name
      source      = attached_disk.value.self_link
    }
    for_each = google_compute_disk.sapddb11_hana_log[*]
  }
  attached_disk {
    device_name = google_compute_disk.sapddb11_hana_shared.name
    source      = google_compute_disk.sapddb11_hana_shared.self_link
  }
  attached_disk {
    device_name = google_compute_disk.sapddb11_hanabackup.name
    source      = google_compute_disk.sapddb11_hanabackup.self_link
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
    enable-oslogin = "FALSE"
    ssh-keys       = ""
  }
  min_cpu_platform = lookup(local.cpu_platform_map, var.db_machine_type, "Automatic")
  name             = length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"
  network_interface {
    dynamic "access_config" {
      content {
      }
      for_each = var.public_ip ? [1] : []
    }
    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapddb11-1.address
    subnetwork = data.google_compute_subnetwork.sap-subnet-db-1.self_link
  }
  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = length(regexall("metal", var.db_machine_type)) > 0 ? "TERMINATE" : "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_db.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone1_name
}

resource "google_compute_instance" "sapddb12" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapddb12_usr_sap.name
    source      = google_compute_disk.sapddb12_usr_sap.self_link
  }
  dynamic "attached_disk" {
    content {
      device_name = attached_disk.value.name
      source      = attached_disk.value.self_link
    }
    for_each = google_compute_disk.sapddb12_hana_data[*]
  }
  dynamic "attached_disk" {
    content {
      device_name = attached_disk.value.name
      source      = attached_disk.value.self_link
    }
    for_each = google_compute_disk.sapddb12_hana_log[*]
  }
  attached_disk {
    device_name = google_compute_disk.sapddb12_hana_shared.name
    source      = google_compute_disk.sapddb12_hana_shared.self_link
  }
  attached_disk {
    device_name = google_compute_disk.sapddb12_hanabackup.name
    source      = google_compute_disk.sapddb12_hanabackup.self_link
  }
  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapddb12.self_link
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
    enable-oslogin = "FALSE"
    ssh-keys       = ""
  }
  min_cpu_platform = lookup(local.cpu_platform_map, var.db_machine_type, "Automatic")
  name             = length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"
  network_interface {
    dynamic "access_config" {
      content {
      }
      for_each = var.public_ip ? [1] : []
    }
    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapddb12-1.address
    subnetwork = data.google_compute_subnetwork.sap-subnet-db-1.self_link
  }
  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = length(regexall("metal", var.db_machine_type)) > 0 ? "TERMINATE" : "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_db.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone2_name
}

resource "google_compute_instance_group" "sapddb11_group" {
  description = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-group"
  instances   = [google_compute_instance.sapddb11.self_link]
  name        = "${length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11"}-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone1_name
}

resource "google_compute_instance_group" "sapddb12_group" {
  description = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-group"
  instances   = [google_compute_instance.sapddb12.self_link]
  name        = "${length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12"}-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone2_name
}

resource "google_compute_region_backend_service" "db_service" {
  backend {
    group = google_compute_instance_group.sapddb11_group.self_link
  }
  backend {
    failover = true
    group    = google_compute_instance_group.sapddb12_group.self_link
  }
  description = "${var.deployment_name}-db-service"
  failover_policy {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  health_checks    = [google_compute_health_check.db_service_health_check.self_link]
  name             = "${var.deployment_name}-db-service"
  project          = data.google_project.sap-project.project_id
  protocol         = "TCP"
  region           = var.region_name
  session_affinity = "CLIENT_IP"
  timeout_sec      = 10
}

resource "google_dns_record_set" "global_master_db" {
  count = var.deployment_has_dns ? 1 : 0
  lifecycle {
    ignore_changes = [rrdatas]
  }
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = "db.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = ["sapddb-vip11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"]
  ttl          = 60
  type         = "CNAME"
}

resource "google_dns_record_set" "ilb_db_1" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = "sapddb-vip11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.db_forwarding_rule.ip_address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapddb11" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = length(var.db_vm_names) > 0 ? "${var.db_vm_names[0]}.${data.google_dns_managed_zone.sap_zone[0].dns_name}" : "${var.vm_prefix}db11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb11.network_interface[0].network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapddb12" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = length(var.db_vm_names) > 1 ? "${var.db_vm_names[1]}.${data.google_dns_managed_zone.sap_zone[0].dns_name}" : "${var.vm_prefix}db12.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb12.network_interface[0].network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_project_iam_member" "db_sa_role_1" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_project_iam_member" "db_sa_role_2" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "db_sa_role_3" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "db_sa_role_4" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/logging.admin"
}

resource "google_project_iam_member" "db_sa_role_5" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.admin"
}

resource "google_project_iam_member" "db_sa_role_6" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.viewer"
}

resource "google_project_iam_member" "db_sa_role_7" {
  count   = var.db_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/workloadmanager.insightWriter"
}

resource "google_service_account" "service_account_db" {
  account_id = "${var.deployment_name}-db"
  count      = var.db_sa_email == "" ? 1 : 0
  project    = data.google_project.sap-project.project_id
}
