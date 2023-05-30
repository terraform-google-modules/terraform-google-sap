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

resource "google_compute_address" "sapddb11-1" {
  address_type = "INTERNAL"
  name         = "${var.vm_prefix}db11-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-db-1.self_link
}

resource "google_compute_address" "sapddb12-1" {
  address_type = "INTERNAL"
  name         = "${var.vm_prefix}db12-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-db-1.self_link
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

resource "google_compute_disk" "sapddb12" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}db12"
  project = data.google_project.sap-project.project_id
  size    = 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_export_backup" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-export-backup"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_export_backup_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_data" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-data"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_data_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_log" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-log"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_log_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_restore" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-restore"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_restore_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-standard"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_hana_shared" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-shared"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_shared_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapddb12_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
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
  project       = data.google_project.sap-project.project_id
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["wlm-db"]
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
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service_account_db.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-db", "allow-health-checks-range"]
  zone = var.zone1_name
}

resource "google_compute_instance" "sapddb12" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapddb12_usr_sap.name
    source      = google_compute_disk.sapddb12_usr_sap.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12_hana_data.name
    source      = google_compute_disk.sapddb12_hana_data.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12_hana_log.name
    source      = google_compute_disk.sapddb12_hana_log.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12_hana_shared.name
    source      = google_compute_disk.sapddb12_hana_shared.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12_export_backup.name
    source      = google_compute_disk.sapddb12_export_backup.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12_hana_restore.name
    source      = google_compute_disk.sapddb12_hana_restore.self_link
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
    ssh-keys = ""
  }
  name = "${var.vm_prefix}db12"
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
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service_account_db.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-db", "allow-health-checks-range"]
  zone = var.zone2_name
}

resource "google_compute_instance_group" "sapddb11_group" {
  description = "${var.vm_prefix}db11-group"
  instances   = [google_compute_instance.sapddb11.self_link]
  name        = "${var.vm_prefix}db11-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone1_name
}

resource "google_compute_instance_group" "sapddb12_group" {
  description = "${var.vm_prefix}db12-group"
  instances   = [google_compute_instance.sapddb12.self_link]
  name        = "${var.vm_prefix}db12-group"
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
  lifecycle {
    ignore_changes = [rrdatas]
  }

  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "db.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = ["sapddb-vip11.${google_dns_managed_zone.sap_zone.dns_name}"]
  ttl          = 60
  type         = "CNAME"
}

resource "google_dns_record_set" "ilb_db_1" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "sapddb-vip11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.db_forwarding_rule.ip_address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapddb11" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}db11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapddb12" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}db12.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb12.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_project_iam_member" "db_sa_role_1" {
  member  = "serviceAccount:${google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_project_iam_member" "db_sa_role_2" {
  member  = "serviceAccount:${google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "db_sa_role_3" {
  member  = "serviceAccount:${google_service_account.service_account_db.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_service_account" "service_account_db" {
  account_id = "${var.deployment_name}-db"
  project    = data.google_project.sap-project.project_id
}
