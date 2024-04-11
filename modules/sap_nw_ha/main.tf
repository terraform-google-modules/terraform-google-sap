/**
 * Copyright 2022 Google LLC
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
#
# Terraform SAP NW HA for Google Cloud
#
# Version:    2.0.202404101403
# Build Hash: 4d5e66e2ca20a6d498491377677dcc2f3579ebd7
#

################################################################################
# Local variables
################################################################################
locals {
  primary_region   = regex("[a-z]*-[a-z1-9]*", var.sap_primary_zone)
  secondary_region = regex("[a-z]*-[a-z1-9]*", var.sap_secondary_zone)
  region           = local.primary_region
  subnetwork_split = split("/", var.subnetwork)
  split_network    = split("/", var.network)
  is_vpc_network   = length(local.split_network) > 1
  ascs             = var.sap_nw_abap == true ? "A" : ""

  sid = lower(var.sap_sid)

  hc_firewall_rule_name = var.hc_firewall_rule_name == "" ? "${local.sid}-hc-allow" : var.hc_firewall_rule_name
  hc_network_tag        = length(var.hc_network_tag) == 0 ? [local.hc_firewall_rule_name] : var.hc_network_tag

  sap_scs_instance_number = var.sap_scs_instance_number == "" ? "00" : var.sap_scs_instance_number
  scs_inst_group_name     = var.scs_inst_group_name == "" ? "${local.sid}-scs-ig" : var.scs_inst_group_name
  scs_hc_name             = var.scs_hc_name == "" ? "${local.sid}-scs-hc" : var.scs_hc_name
  scs_hc_port             = var.scs_hc_port == "" ? "600${local.sap_scs_instance_number}" : var.scs_hc_port
  scs_vip_name            = var.scs_vip_name == "" ? "${local.sid}-scs-vip" : var.scs_vip_name
  scs_vip_address         = var.scs_vip_address == "" ? "" : var.scs_vip_address
  scs_backend_svc_name    = var.scs_backend_svc_name == "" ? "${local.sid}-scs-backend-svc" : var.scs_backend_svc_name
  scs_forw_rule_name      = var.scs_forw_rule_name == "" ? "${local.sid}-scs-fwd-rule" : var.scs_forw_rule_name

  sap_ers_instance_number = var.sap_ers_instance_number == "" ? "10" : var.sap_ers_instance_number
  ers_inst_group_name     = var.ers_inst_group_name == "" ? "${local.sid}-ers-ig" : var.ers_inst_group_name
  ers_hc_name             = var.ers_hc_name == "" ? "${local.sid}-ers-hc" : var.ers_hc_name
  ers_hc_port             = var.ers_hc_port == "" ? "600${local.sap_ers_instance_number}" : var.ers_hc_port
  ers_vip_name            = var.ers_vip_name == "" ? "${local.sid}-ers-vip" : var.ers_vip_name
  ers_vip_address         = var.ers_vip_address == "" ? "" : var.ers_vip_address
  ers_backend_svc_name    = var.ers_backend_svc_name == "" ? "${local.sid}-ers-backend-svc" : var.ers_backend_svc_name
  ers_forw_rule_name      = var.ers_forw_rule_name == "" ? "${local.sid}-ers-fwd-rule" : var.ers_forw_rule_name

  pacemaker_cluster_name = var.pacemaker_cluster_name == "" ? "${local.sid}-cluster" : var.pacemaker_cluster_name
  subnetwork_uri = length(local.subnetwork_split) > 1 ? (
    "projects/${local.subnetwork_split[0]}/regions/${local.region}/subnetworks/${local.subnetwork_split[1]}") : (
  "projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnetwork}")

  primary_startup_url   = var.sap_deployment_debug ? replace(var.primary_startup_url, "bash -s", "bash -x -s") : var.primary_startup_url
  secondary_startup_url = var.sap_deployment_debug ? replace(var.secondary_startup_url, "bash -s", "bash -x -s") : var.secondary_startup_url
}

################################################################################
# disks
################################################################################
resource "google_compute_disk" "nw_boot_disks" {
  count   = 2
  name    = count.index == 0 ? "${var.sap_primary_instance}-boot" : "${var.sap_secondary_instance}-boot"
  type    = "pd-balanced"
  zone    = count.index == 0 ? var.sap_primary_zone : var.sap_secondary_zone
  size    = 30
  image   = "${var.linux_image_project}/${var.linux_image}"
  project = var.project_id

  lifecycle {
    # Ignores newer versions of the OS image. Removing this lifecycle
    # and re-applying will cause the current disk to be deleted.
    # All existing data will be lost.
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "nw_usr_sap_disks" {
  count   = 2
  name    = count.index == 0 ? "${var.sap_primary_instance}-usrsap" : "${var.sap_secondary_instance}-usrsap"
  type    = "pd-balanced"
  zone    = count.index == 0 ? var.sap_primary_zone : var.sap_secondary_zone
  size    = var.usr_sap_size
  project = var.project_id
}

resource "google_compute_disk" "nw_sapmnt_disks" {
  count   = 2
  name    = count.index == 0 ? "${var.sap_primary_instance}-sapmnt" : "${var.sap_secondary_instance}-sapmnt"
  type    = "pd-balanced"
  zone    = count.index == 0 ? var.sap_primary_zone : var.sap_secondary_zone
  size    = var.sap_mnt_size
  project = var.project_id
}

resource "google_compute_disk" "nw_swap_disks" {
  count   = var.swap_size > 0 ? 2 : 0
  name    = count.index == 0 ? "${var.sap_primary_instance}-swap" : "${var.sap_secondary_instance}-swap"
  type    = "pd-balanced"
  zone    = count.index == 0 ? var.sap_primary_zone : var.sap_secondary_zone
  size    = var.swap_size
  project = var.project_id
}

################################################################################
# VM VIPs
################################################################################

resource "google_compute_address" "sap_nw_vm_ip" {
  count        = 2
  name         = count.index == 0 ? "${var.sap_primary_instance}-ip" : "${var.sap_secondary_instance}-ip"
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
}

################################################################################
# instances
################################################################################
resource "google_compute_instance" "scs_instance" {
  name         = var.sap_primary_instance
  machine_type = var.machine_type
  zone         = var.sap_primary_zone
  project      = var.project_id

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.nw_boot_disks[0].self_link
  }

  attached_disk {
    device_name = google_compute_disk.nw_usr_sap_disks[0].name
    source      = google_compute_disk.nw_usr_sap_disks[0].self_link
  }
  attached_disk {
    device_name = google_compute_disk.nw_sapmnt_disks[0].name
    source      = google_compute_disk.nw_sapmnt_disks[0].self_link
  }
  dynamic "attached_disk" {
    for_each = var.swap_size > 0 ? [1] : []
    content {
      device_name = google_compute_disk.nw_swap_disks[0].name
      source      = google_compute_disk.nw_swap_disks[0].self_link
    }
  }

  can_ip_forward = var.can_ip_forward
  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_nw_vm_ip[0].address
    # we only include access_config if public_ip is true, an empty access_config
    # will create an ephemeral public ip
    dynamic "access_config" {
      for_each = var.public_ip ? [1] : []
      content {
      }
    }
  }
  tags = flatten([var.network_tags, local.hc_network_tag])
  service_account {
    # An empty string service account will default to the projects default compute engine service account
    email = var.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  dynamic "reservation_affinity" {
    for_each = length(var.primary_reservation_name) > 1 ? [1] : []
    content {
      type = "SPECIFIC_RESERVATION"
      specific_reservation {
        key    = "compute.googleapis.com/reservation-name"
        values = [var.primary_reservation_name]
      }
    }
  }
  metadata = {
    startup-script = local.primary_startup_url

    # SCS settings
    sap_primary_instance = var.sap_primary_instance
    sap_primary_zone     = var.sap_primary_zone
    scs_hc_port          = local.scs_hc_port
    scs_vip_address      = google_compute_address.nw_vips[0].address
    scs_vip_name         = local.scs_vip_name

    # ERS settings
    sap_secondary_instance = var.sap_secondary_instance
    sap_secondary_zone     = var.sap_secondary_zone
    ers_hc_port            = local.ers_hc_port
    ers_vip_address        = google_compute_address.nw_vips[1].address
    ers_vip_name           = local.ers_vip_name

    # File system settings
    nfs_path = var.nfs_path

    # SAP system settings
    sap_sid                 = upper(var.sap_sid)
    sap_scs_instance_number = local.sap_scs_instance_number
    sap_ers_instance_number = local.sap_ers_instance_number
    sap_ascs                = local.ascs

    # Pacemaker settings
    pacemaker_cluster_name = local.pacemaker_cluster_name

    # Other
    sap_deployment_debug   = var.sap_deployment_debug ? "True" : "False"
    post_deployment_script = var.post_deployment_script
    template-type          = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}

resource "google_compute_instance" "ers_instance" {
  name         = var.sap_secondary_instance
  machine_type = var.machine_type
  zone         = var.sap_secondary_zone
  project      = var.project_id

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.nw_boot_disks[1].self_link
  }

  attached_disk {
    device_name = google_compute_disk.nw_usr_sap_disks[1].name
    source      = google_compute_disk.nw_usr_sap_disks[1].self_link
  }
  attached_disk {
    device_name = google_compute_disk.nw_sapmnt_disks[1].name
    source      = google_compute_disk.nw_sapmnt_disks[1].self_link
  }
  dynamic "attached_disk" {
    for_each = var.swap_size > 0 ? [1] : []
    content {
      device_name = google_compute_disk.nw_swap_disks[1].name
      source      = google_compute_disk.nw_swap_disks[1].self_link
    }
  }

  can_ip_forward = var.can_ip_forward
  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_nw_vm_ip[1].address
    # we only include access_config if public_ip is true, an empty access_config
    # will create an ephemeral public ip
    dynamic "access_config" {
      for_each = var.public_ip ? [1] : []
      content {
      }
    }
  }
  tags = flatten([var.network_tags, local.hc_network_tag])
  service_account {
    # An empty string service account will default to the projects default compute engine service account
    email = var.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  dynamic "reservation_affinity" {
    for_each = length(var.secondary_reservation_name) > 1 ? [1] : []
    content {
      type = "SPECIFIC_RESERVATION"
      specific_reservation {
        key    = "compute.googleapis.com/reservation-name"
        values = [var.secondary_reservation_name]
      }
    }
  }
  metadata = {
    startup-script = local.secondary_startup_url

    # SCS settings
    sap_primary_instance = var.sap_primary_instance
    sap_primary_zone     = var.sap_primary_zone
    scs_hc_port          = local.scs_hc_port
    scs_vip_address      = google_compute_address.nw_vips[0].address
    scs_vip_name         = local.scs_vip_name

    # ERS settings
    sap_secondary_instance = var.sap_secondary_instance
    sap_secondary_zone     = var.sap_secondary_zone
    ers_hc_port            = local.ers_hc_port
    ers_vip_address        = google_compute_address.nw_vips[1].address
    ers_vip_name           = local.ers_vip_name

    # File system settings
    nfs_path = var.nfs_path

    # SAP system settings
    sap_sid                 = upper(var.sap_sid)
    sap_scs_instance_number = local.sap_scs_instance_number
    sap_ers_instance_number = local.sap_ers_instance_number
    sap_ascs                = local.ascs

    # Pacemaker settings
    pacemaker_cluster_name = local.pacemaker_cluster_name

    # Other
    sap_deployment_debug   = var.sap_deployment_debug ? "True" : "False"
    post_deployment_script = var.post_deployment_script
    template-type          = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}
################################################################################
# NW VIPs
################################################################################
resource "google_compute_address" "nw_vips" {
  count        = 2
  name         = count.index == 0 ? local.scs_vip_name : local.ers_vip_name
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  address      = count.index == 0 ? local.scs_vip_address : local.ers_vip_address
  region       = count.index == 0 ? local.primary_region : local.secondary_region
  project      = var.project_id
}

################################################################################
# IGs
################################################################################
resource "google_compute_instance_group" "nw_instance_groups" {
  count     = 2
  name      = count.index == 0 ? local.scs_inst_group_name : local.ers_inst_group_name
  instances = count.index == 0 ? google_compute_instance.scs_instance[*].self_link : google_compute_instance.ers_instance[*].self_link
  zone      = count.index == 0 ? var.sap_primary_zone : var.sap_secondary_zone
  project   = var.project_id
}

################################################################################
# Health Checks
################################################################################
resource "google_compute_health_check" "nw_hc" {
  count               = 2
  name                = count.index == 0 ? local.scs_hc_name : local.ers_hc_name
  timeout_sec         = 10
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 2
  project             = var.project_id

  tcp_health_check {
    port = count.index == 0 ? local.scs_hc_port : local.ers_hc_port
  }
}

################################################################################
# Firewall rule for the Health Checks
################################################################################
resource "google_compute_firewall" "nw_hc_firewall_rule" {
  name          = local.hc_firewall_rule_name
  count         = local.is_vpc_network ? 0 : 1
  network       = var.network
  direction     = "INGRESS"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = local.hc_network_tag
  project       = var.project_id

  allow {
    protocol = "tcp"
    ports    = [local.scs_hc_port, local.ers_hc_port]
  }
}

################################################################################
# Backend services
################################################################################
resource "google_compute_region_backend_service" "nw_regional_backend_services" {
  count                 = 2
  name                  = count.index == 0 ? local.scs_backend_svc_name : local.ers_backend_svc_name
  region                = local.region
  load_balancing_scheme = "INTERNAL"
  health_checks         = [element(google_compute_health_check.nw_hc[*].id, count.index)]
  project               = var.project_id

  failover_policy {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }
  backend {
    group    = element(google_compute_instance_group.nw_instance_groups[*].id, count.index)
    failover = false
  }
  backend {
    group    = element(google_compute_instance_group.nw_instance_groups[*].id, 1 - count.index)
    failover = true
  }
}

################################################################################
# Forwarding Rules
################################################################################
resource "google_compute_forwarding_rule" "nw_forwarding_rules" {
  count                 = 2
  name                  = count.index == 0 ? local.scs_forw_rule_name : local.ers_forw_rule_name
  ip_address            = element(google_compute_address.nw_vips[*].address, count.index)
  region                = local.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = element(google_compute_region_backend_service.nw_regional_backend_services[*].id, count.index)
  all_ports             = true
  subnetwork            = local.subnetwork_uri
  project               = var.project_id
}
