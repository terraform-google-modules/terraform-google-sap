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

data "google_compute_subnetwork" "sap-subnet-ascs-1" {
  name    = var.subnet_name
  project = data.google_compute_network.sap-vpc.project
  region  = var.region_name
}

data "google_service_account" "service_account_ascs" {
  account_id = var.ascs_sa_email == "" ? google_service_account.service_account_ascs[0].email : var.ascs_sa_email
}

resource "google_compute_address" "sapdascs11-1" {
  address_type = "INTERNAL"
  name         = "${length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11"}-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
}

resource "google_compute_address" "sapdascs12-1" {
  address_type = "INTERNAL"
  name         = "${length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12"}-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
}

resource "google_compute_disk" "sapdascs11" {
  image = var.sap_boot_disk_image_ascs == "" ? var.sap_boot_disk_image : var.sap_boot_disk_image_ascs
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11"
  project = data.google_project.sap-project.project_id
  size    = length(regexall("metal|c4-", var.ascs_machine_type)) > 0 ? 64 : 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = length(regexall("metal|c4-", var.ascs_machine_type)) > 0 ? "hyperdisk-balanced" : "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapdascs11_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11"}-usr-sap"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.ascs_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (lookup(var.disk_size_map, "ascs_disk_usr_sap_size", var.ascs_disk_usr_sap_size))) : null
  size             = lookup(var.disk_size_map, "ascs_disk_usr_sap_size", var.ascs_disk_usr_sap_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.ascs_disk_type
  zone = var.zone1_name
}

resource "google_compute_disk" "sapdascs12" {
  image = var.sap_boot_disk_image_ascs == "" ? var.sap_boot_disk_image : var.sap_boot_disk_image_ascs
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12"
  project = data.google_project.sap-project.project_id
  size    = length(regexall("metal|c4-", var.ascs_machine_type)) > 0 ? 64 : 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = length(regexall("metal|c4-", var.ascs_machine_type)) > 0 ? "hyperdisk-balanced" : "pd-ssd"
  zone = var.zone2_name
}

resource "google_compute_disk" "sapdascs12_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }
  name             = "${length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12"}-usr-sap"
  project          = data.google_project.sap-project.project_id
  provisioned_iops = var.ascs_disk_type == "hyperdisk-extreme" ? max(10000, 2 * (lookup(var.disk_size_map, "ascs_disk_usr_sap_size", var.ascs_disk_usr_sap_size))) : null
  size             = lookup(var.disk_size_map, "ascs_disk_usr_sap_size", var.ascs_disk_usr_sap_size)
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = var.ascs_disk_type
  zone = var.zone2_name
}

resource "google_compute_firewall" "ilb_firewall_ascs" {
  allow {
    ports    = [var.ascs_ilb_healthcheck_port]
    protocol = "tcp"
  }
  description   = "Google-FW-LB"
  name          = "ilb-firewall-ascs-${var.deployment_name}"
  network       = data.google_compute_network.sap-vpc.self_link
  project       = data.google_compute_network.sap-vpc.project
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = google_compute_instance.sapdascs11.tags
}

resource "google_compute_firewall" "ilb_firewall_ers" {
  allow {
    ports    = [var.ers_ilb_healthcheck_port]
    protocol = "tcp"
  }
  description   = "Google-FW-LB"
  name          = "ilb-firewall-ers-${var.deployment_name}"
  network       = data.google_compute_network.sap-vpc.self_link
  project       = data.google_compute_network.sap-vpc.project
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = google_compute_instance.sapdascs11.tags
}

resource "google_compute_forwarding_rule" "ascs_forwarding_rule" {
  all_ports             = true
  allow_global_access   = true
  backend_service       = google_compute_region_backend_service.ascs_service.self_link
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  name                  = "${var.deployment_name}-ascs-forwarding-rule"
  network               = data.google_compute_network.sap-vpc.self_link
  project               = data.google_project.sap-project.project_id
  region                = var.region_name
  subnetwork            = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
}

resource "google_compute_forwarding_rule" "ers_forwarding_rule" {
  all_ports             = true
  allow_global_access   = true
  backend_service       = google_compute_region_backend_service.ers_service.self_link
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  name                  = "${var.deployment_name}-ers-forwarding-rule"
  network               = data.google_compute_network.sap-vpc.self_link
  project               = data.google_project.sap-project.project_id
  region                = var.region_name
  subnetwork            = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
}

resource "google_compute_health_check" "ascs_service_health_check" {
  check_interval_sec = 10
  name               = "${var.deployment_name}-ascs-service-health-check"
  project            = data.google_project.sap-project.project_id
  tcp_health_check {
    port = var.ascs_ilb_healthcheck_port
  }
  timeout_sec = 10
}

resource "google_compute_health_check" "ers_service_health_check" {
  check_interval_sec = 10
  name               = "${var.deployment_name}-ers-service-health-check"
  project            = data.google_project.sap-project.project_id
  tcp_health_check {
    port = var.ers_ilb_healthcheck_port
  }
  timeout_sec = 10
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
  metadata = merge(var.custom_ascs_metadata, {
    enable-oslogin = "FALSE"
    ssh-keys       = ""
  })
  min_cpu_platform = lookup(local.cpu_platform_map, var.ascs_machine_type, "Automatic")
  name             = length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11"
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
    on_host_maintenance = length(regexall("metal", var.ascs_machine_type)) > 0 ? "TERMINATE" : "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_ascs.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone1_name
}

resource "google_compute_instance" "sapdascs12" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdascs12_usr_sap.name
    source      = google_compute_disk.sapdascs12_usr_sap.self_link
  }
  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdascs12.self_link
  }
  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }
  machine_type = var.ascs_machine_type
  metadata = merge(var.custom_ascs_metadata, {
    enable-oslogin = "FALSE"
    ssh-keys       = ""
  }) 
  min_cpu_platform = lookup(local.cpu_platform_map, var.ascs_machine_type, "Automatic")
  name             = length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12"
  network_interface {
    dynamic "access_config" {
      content {
      }
      for_each = var.public_ip ? [1] : []
    }
    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapdascs12-1.address
    subnetwork = data.google_compute_subnetwork.sap-subnet-ascs-1.self_link
  }
  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = length(regexall("metal", var.ascs_machine_type)) > 0 ? "TERMINATE" : "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_ascs.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone2_name
}

resource "google_compute_instance_group" "sapdascs11_group" {
  description = "${length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11"}-group"
  instances   = [google_compute_instance.sapdascs11.self_link]
  name        = "${length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11"}-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone1_name
}

resource "google_compute_instance_group" "sapdascs12_group" {
  description = "${length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12"}-group"
  instances   = [google_compute_instance.sapdascs12.self_link]
  name        = "${length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12"}-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone2_name
}

resource "google_compute_region_backend_service" "ascs_service" {
  backend {
    group = google_compute_instance_group.sapdascs11_group.self_link
  }
  backend {
    failover = true
    group    = google_compute_instance_group.sapdascs12_group.self_link
  }
  description = "${var.deployment_name}-ascs-service"
  failover_policy {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  health_checks = [
    google_compute_health_check.ascs_service_health_check.self_link
  ]
  name             = "${var.deployment_name}-ascs-service"
  project          = data.google_project.sap-project.project_id
  protocol         = "TCP"
  region           = var.region_name
  session_affinity = "CLIENT_IP"
  timeout_sec      = 10
}

resource "google_compute_region_backend_service" "ers_service" {
  backend {
    group = google_compute_instance_group.sapdascs11_group.self_link
  }
  backend {
    failover = true
    group    = google_compute_instance_group.sapdascs12_group.self_link
  }
  description = "${var.deployment_name}-ers-service"
  failover_policy {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  health_checks = [
    google_compute_health_check.ers_service_health_check.self_link
  ]
  name             = "${var.deployment_name}-ers-service"
  project          = data.google_project.sap-project.project_id
  protocol         = "TCP"
  region           = var.region_name
  session_affinity = "CLIENT_IP"
  timeout_sec      = 10
}

resource "google_dns_record_set" "ascs_alidascs11" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = "alidascs11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_dns_record_set.ilb_ascs_1[0].name]
  ttl          = 300
  type         = "CNAME"
}

resource "google_dns_record_set" "ascs_aliders11" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = "aliders11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_dns_record_set.ilb_ers_1[0].name]
  ttl          = 300
  type         = "CNAME"
}

resource "google_dns_record_set" "ilb_ascs_1" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = "sapdascs-vip11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.ascs_forwarding_rule.ip_address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "ilb_ers_1" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = "sapders-vip11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.ers_forwarding_rule.ip_address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapdascs11" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = length(var.ascs_vm_names) > 0 ? "${var.ascs_vm_names[0]}.${data.google_dns_managed_zone.sap_zone[0].dns_name}" : "${var.vm_prefix}ascs11.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs11.network_interface[0].network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapdascs12" {
  count        = var.deployment_has_dns ? 1 : 0
  managed_zone = data.google_dns_managed_zone.sap_zone[0].name
  name         = length(var.ascs_vm_names) > 1 ? "${var.ascs_vm_names[1]}.${data.google_dns_managed_zone.sap_zone[0].dns_name}" : "${var.vm_prefix}ascs12.${data.google_dns_managed_zone.sap_zone[0].dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs12.network_interface[0].network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_project_iam_member" "ascs_sa_role_1" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_project_iam_member" "ascs_sa_role_2" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "ascs_sa_role_3" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "ascs_sa_role_4" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/logging.admin"
}

resource "google_project_iam_member" "ascs_sa_role_5" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.admin"
}

resource "google_project_iam_member" "ascs_sa_role_6" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.viewer"
}

resource "google_project_iam_member" "ascs_sa_role_7" {
  count   = var.ascs_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/workloadmanager.insightWriter"
}

resource "google_service_account" "service_account_ascs" {
  account_id = "${var.deployment_name}-ascs"
  count      = var.ascs_sa_email == "" ? 1 : 0
  project    = data.google_project.sap-project.project_id
}
