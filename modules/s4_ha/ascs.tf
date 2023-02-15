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

resource "google_compute_address" "alidascs11" {
  address_type = "INTERNAL"
  name         = "alidascs11"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = google_compute_instance.sapdascs11.network_interface[0].subnetwork
}

resource "google_compute_address" "aliders11" {
  address_type = "INTERNAL"
  name         = "aliders11"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = google_compute_instance.sapdascs12.network_interface[0].subnetwork
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

  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_disk" "sapdascs12" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}ascs12"
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

resource "google_compute_disk" "sapdascs12_usr_sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}ascs12-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.ascs_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
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
  subnetwork            = google_compute_instance.sapdascs11.network_interface[0].subnetwork
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
  subnetwork            = google_compute_instance.sapdascs11.network_interface[0].subnetwork
}

resource "google_compute_health_check" "ascs_service_health_check" {
  check_interval_sec = 10
  name               = "${var.deployment_name}-ascs-service-health-check"
  project            = data.google_project.sap-project.project_id
  tcp_health_check {
    port = "60000"
  }

  timeout_sec = 10
}

resource "google_compute_health_check" "ers_service_health_check" {
  check_interval_sec = 10
  name               = "${var.deployment_name}-ers-service-health-check"
  project            = data.google_project.sap-project.project_id
  tcp_health_check {
    port = "60010"
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
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}ascs11"
  network_interface {
    access_config {
    }

    network = data.google_compute_network.sap-vpc.self_link
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

  tags = ["wlm-ascs"]
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
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}ascs12"
  network_interface {
    access_config {
    }

    network = data.google_compute_network.sap-vpc.self_link
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

  tags = ["wlm-ascs"]
  zone = var.zone2_name
}

resource "google_compute_instance_group" "sapdascs11_group" {
  description = "sapdascs11-group"
  instances   = [google_compute_instance.sapdascs11.self_link]
  name        = "sapdascs11-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone1_name
}

resource "google_compute_instance_group" "sapdascs12_group" {
  description = "sapdascs12-group"
  instances   = [google_compute_instance.sapdascs12.self_link]
  name        = "sapdascs12-group"
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
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "alidascs11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_address.alidascs11.address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "ascs_aliders11" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "aliders11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_address.aliders11.address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "ilb_ascs_1" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "sapdascs-vip11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.ascs_forwarding_rule.ip_address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "ilb_ers_1" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "sapders-vip11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.ers_forwarding_rule.ip_address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapdascs11" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}ascs11.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "to_vm_sapdascs12" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "${var.vm_prefix}ascs12.${google_dns_managed_zone.sap_zone.dns_name}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs12.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_project_iam_member" "ascs_sa_role_1" {
  member  = "serviceAccount:${google_service_account.service_account_ascs.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_service_account" "service_account_ascs" {
  account_id = "sap-ascs-role-${var.deployment_name}"
  project    = data.google_project.sap-project.project_id
}
