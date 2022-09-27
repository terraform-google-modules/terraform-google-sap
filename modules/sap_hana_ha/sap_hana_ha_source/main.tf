#
# Terraform SAP HANA HA for Google Cloud
#
# Version:    2.0.2022092713131664309621
# Build Hash: 32c641555bd6b4e0fc61df16a22f48913d50bacf
#

################################################################################
# Local variables
################################################################################
locals {
  mem_size_map = {
    "n1-highmem-32"   = 208
    "n1-highmem-64"   = 416
    "n1-highmem-96"   = 624
    "n1-megamem-96"   = 1433
    "n2-highmem-32"   = 256
    "n2-highmem-48"   = 386
    "n2-highmem-64"   = 512
    "n2-highmem-80"   = 640
    "n2-highmem-96"   = 768
    "n2-highmem-128"  = 864
    "n1-ultramem-40"  = 961
    "n1-ultramem-80"  = 1922
    "n1-ultramem-160" = 3844
    "m1-megamem-96"   = 1433
    "m1-ultramem-40"  = 961
    "m1-ultramem-80"  = 1922
    "m1-ultramem-160" = 3844
    "m2-ultramem-208" = 5916
    "m2-megamem-416"  = 5916
    "m2-hypermem-416" = 8832
    "m2-ultramem-416" = 11832
  }
  cpu_platform_map = {
    "n1-highmem-32"   = "Intel Broadwell"
    "n1-highmem-64"   = "Intel Broadwell"
    "n1-highmem-96"   = "Intel Skylake"
    "n1-megamem-96"   = "Intel Skylake"
    "n2-highmem-32"   = "Automatic"
    "n2-highmem-48"   = "Automatic"
    "n2-highmem-64"   = "Automatic"
    "n2-highmem-80"   = "Automatic"
    "n2-highmem-96"   = "Automatic"
    "n2-highmem-128"  = "Automatic"
    "n1-ultramem-40"  = "Automatic"
    "n1-ultramem-80"  = "Automatic"
    "n1-ultramem-160" = "Automatic"
    "m1-megamem-96"   = "Intel Skylake"
    "m1-ultramem-40"  = "Automatic"
    "m1-ultramem-80"  = "Automatic"
    "m1-ultramem-160" = "Automatic"
    "m2-ultramem-208" = "Automatic"
    "m2-megamem-416"  = "Automatic"
    "m2-hypermem-416" = "Automatic"
    "m2-ultramem-416" = "Automatic"
  }
  mem_size = lookup(local.mem_size_map, var.machine_type, 320)
  hana_log_size_min = min(512, max(64, local.mem_size / 2))
  hana_data_size_min = local.mem_size * 12 / 10
  hana_shared_size_min = min(1024, local.mem_size)

  default_boot_size = 30

  hana_log_size = local.hana_log_size_min
  hana_data_size = local.hana_data_size_min

  all_network_tag_items = concat(var.network_tags, ["sap-${local.healthcheck_name}-port"])
  network_tags = local.all_network_tag_items

  pdhdd_size = var.sap_hana_backup_size > 0 ? var.sap_hana_backup_size : 2 * local.mem_size

  # ensure pd-ssd meets minimum size/performance
  pdssd_size = ceil(max(834, local.hana_log_size + local.hana_data_size + local.hana_shared_size_min + 32 + 1))

  sap_vip_solution = "ILB"
  sap_hc_port = 60000 + var.sap_hana_instance_number

  # Note that you can not have default values refernce another variable value
  primary_instance_group_name = var.primary_instance_group_name != "" ? var.primary_instance_group_name : "ig-${var.primary_instance_name}"
  secondary_instance_group_name = var.secondary_instance_group_name != "" ? var.secondary_instance_group_name : "ig-${var.secondary_instance_name}"
  loadbalancer_name_prefix = "${var.loadbalancer_name != "" ? var.loadbalancer_name : "lb-${lower(var.sap_hana_sid)}"}"
  loadbalancer_name = "${local.loadbalancer_name_prefix}-ilb"
  loadbalancer_address_name = "${local.loadbalancer_name_prefix}-address"
  loadbalancer_address = var.sap_vip
  healthcheck_name = "${local.loadbalancer_name_prefix}-hc"
  forwardingrule_name = "${local.loadbalancer_name_prefix}-fwr"

  split_network = split("/", var.network)
  is_vpc_network = length(local.split_network) > 1

  # Network: with Shared VPC option with ILB
  processed_network = local.is_vpc_network ? (
    "https://www.googleapis.com/compute/v1/projects/${local.split_network[0]}/global/networks/${local.split_network[1]}"
    ) : (
    "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${var.network}"
  )

  # network config variables
  zone_split = split("-", var.primary_zone)
  region = "${local.zone_split[0]}-${local.zone_split[1]}"
  subnetwork_split = split("/", var.subnetwork)

  subnetwork_uri = length(local.subnetwork_split) > 1 ? (
      "https://www.googleapis.com/compute/v1/projects/${local.subnetwork_split[0]}/regions/${local.region}/subnetworks/${local.subnetwork_split[1]}") : (
      "https://www.googleapis.com/compute/v1/projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnetwork}")

  os_full_name = "${var.linux_image_project}/${var.linux_image}"

  # WLM Information
  wlm_labels = var.is_work_load_management_deployment ? (
    { goog-workload = var.wlm_deployment_name
      sap-ha = "sap-ha"
      sap-nw = "sap-nw"
      sap-hana = "sap-hana"
     } ) : ( {}
  )

  wlm_metadata = var.is_work_load_management_deployment ? (
    {
      goog-wl-sap-product = "sap-hana-ha-v1"
      goog-wl-sap-sid = var.sap_hana_sid
      goog-wl-os = local.os_full_name

    } ) : {}
}

################################################################################
# VIPs
################################################################################

resource "google_compute_address" "sap_hana_ha_vm_ip" {
  count        = 2
  name         = count.index == 0 ? "${var.primary_instance_name}-ip" : "${var.secondary_instance_name}-ip"
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
}


################################################################################
# Primary Instance
################################################################################
################################################################################
# disks
################################################################################
resource "google_compute_disk" "sap_hana_ha_primary_boot_disk" {
  name = "${var.primary_instance_name}-boot"
  type = "pd-standard"
  zone = var.primary_zone
  size = local.default_boot_size
  project = var.project_id
  image = local.os_full_name

  lifecycle {
    # Ignores newer versions of the OS image. Removing this lifecycle
    # and re-applying will cause the current disk to be deleted.
    # All existing data will be lost.
    ignore_changes = [image]
  }
}
resource "google_compute_disk" "sap_hana_ha_primary_pdssd_disk" {
  name = "${var.primary_instance_name}-pdssd"
  type = "pd-ssd"
  zone = var.primary_zone
  size = local.pdssd_size
  project = var.project_id
}
resource "google_compute_disk" "sap_hana_ha_primary_backup_disk" {
  name = "${var.primary_instance_name}-backup"
  type = "pd-standard"
  zone = var.primary_zone
  size = local.pdhdd_size
  project = var.project_id
}

################################################################################
# instance
################################################################################
resource "google_compute_instance" "sap_hana_ha_primary_instance" {
  name = var.primary_instance_name
  machine_type = var.machine_type
  zone = var.primary_zone
  project = var.project_id

  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source = google_compute_disk.sap_hana_ha_primary_boot_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_ha_primary_pdssd_disk.name
    source = google_compute_disk.sap_hana_ha_primary_pdssd_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_ha_primary_backup_disk.name
    source = google_compute_disk.sap_hana_ha_primary_backup_disk.self_link
  }

  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_ha_vm_ip.0.address

    # we only include access_config if public_ip is true, an empty access_config
    # will create an ephemeral public ip
    dynamic "access_config" {
      for_each = var.public_ip ? [1] : []
      content {
      }
    }
  }

  tags = local.network_tags

  service_account {
    # The default empty service account string will use the projects default compute engine service account
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
        key = "compute.googleapis.com/reservation-name"
        values = [var.primary_reservation_name]
      }
    }
  }

  labels = local.wlm_labels

  metadata = merge(
    {
      startup-script = var.primary_startup_url
      post_deployment_script = var.post_deployment_script
      sap_deployment_debug = var.sap_deployment_debug
      sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
      sap_hana_sid = var.sap_hana_sid
      sap_hana_instance_number = var.sap_hana_instance_number
      sap_hana_sidadm_password = var.sap_hana_sidadm_password
      sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
      # wording on system_password may be inconsitent with DM
      sap_hana_system_password = var.sap_hana_system_password
      sap_hana_system_password_secret = var.sap_hana_system_password_secret
      sap_hana_sidadm_uid = var.sap_hana_sidadm_uid
      sap_hana_sapsys_gid = var.sap_hana_sapsys_gid
      sap_vip = var.sap_vip
      sap_vip_solution = local.sap_vip_solution
      sap_hc_port = local.sap_hc_port
      sap_primary_instance = var.primary_instance_name
      sap_secondary_instance = var.secondary_instance_name
      sap_primary_zone = var.primary_zone
      sap_secondary_zone = var.secondary_zone
      template-type = "TERRAFORM"
    },
    local.wlm_metadata
  )

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}

################################################################################
# Secondary Instance
################################################################################
################################################################################
# disks
################################################################################
resource "google_compute_disk" "sap_hana_ha_secondary_boot_disk" {
  name = "${var.secondary_instance_name}-boot"
  type = "pd-standard"
  zone = var.secondary_zone
  size = local.default_boot_size
  project = var.project_id
  image = local.os_full_name

  lifecycle {
    # Ignores newer versions of the OS image. Removing this lifecycle
    # and re-applying will cause the current disk to be deleted.
    # All existing data will be lost.
    ignore_changes = [image]
  }
}
resource "google_compute_disk" "sap_hana_ha_secondary_pdssd_disk" {
  name = "${var.secondary_instance_name}-pdssd"
  type = "pd-ssd"
  zone = var.secondary_zone
  size = local.pdssd_size
  project = var.project_id
}
resource "google_compute_disk" "sap_hana_ha_secondary_backup_disk" {
  name = "${var.secondary_instance_name}-backup"
  type = "pd-standard"
  zone = var.secondary_zone
  size = local.pdhdd_size
  project = var.project_id
}

################################################################################
# instance
################################################################################
resource "google_compute_instance" "sap_hana_ha_secondary_instance" {
  name = var.secondary_instance_name
  machine_type = var.machine_type
  zone = var.secondary_zone
  project = var.project_id

  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source = google_compute_disk.sap_hana_ha_secondary_boot_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_ha_secondary_pdssd_disk.name
    source = google_compute_disk.sap_hana_ha_secondary_pdssd_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_ha_secondary_backup_disk.name
    source = google_compute_disk.sap_hana_ha_secondary_backup_disk.self_link
  }

  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_ha_vm_ip.1.address
    # we only include access_config if public_ip is true, an empty access_config
    # will create an ephemeral public ip
    dynamic "access_config" {
      for_each = var.public_ip ? [1] : []
      content {
      }
    }
  }

  tags = local.network_tags

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
        key = "compute.googleapis.com/reservation-name"
        values = [var.secondary_reservation_name]
      }
    }
  }

  labels = local.wlm_labels

  metadata = merge(
    {
      startup-script = var.secondary_startup_url
      post_deployment_script = var.post_deployment_script
      sap_deployment_debug = var.sap_deployment_debug
      sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
      sap_hana_sid = var.sap_hana_sid
      sap_hana_instance_number = var.sap_hana_instance_number
      sap_hana_sidadm_password = var.sap_hana_sidadm_password
      sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
      # wording on system_password may be inconsitent with DM
      sap_hana_system_password = var.sap_hana_system_password
      sap_hana_system_password_secret = var.sap_hana_system_password_secret
      sap_hana_sidadm_uid = var.sap_hana_sidadm_uid
      sap_hana_sapsys_gid = var.sap_hana_sapsys_gid
      sap_vip = var.sap_vip
      sap_vip_solution = local.sap_vip_solution
      sap_hc_port = local.sap_hc_port
      sap_primary_instance = var.primary_instance_name
      sap_secondary_instance = var.secondary_instance_name
      sap_primary_zone = var.primary_zone
      sap_secondary_zone = var.secondary_zone
      template-type = "TERRAFORM"
    },
    local.wlm_metadata
  )

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}


################################################################################
# Optional ILB for VIP
################################################################################
resource "google_compute_instance_group" "sap_hana_ha_primary_instance_group" {
  name = local.primary_instance_group_name
  zone = var.primary_zone
  instances = [google_compute_instance.sap_hana_ha_primary_instance.id]
  project = var.project_id
}

resource "google_compute_instance_group" "sap_hana_ha_secondary_instance_group" {
  name = local.secondary_instance_group_name
  zone = var.secondary_zone
  instances = [google_compute_instance.sap_hana_ha_secondary_instance.id]
  project = var.project_id
}

resource "google_compute_region_backend_service" "sap_hana_ha_loadbalancer" {
  name = local.loadbalancer_name
  region = local.region
  project = var.project_id
  network = local.processed_network
  health_checks = [google_compute_health_check.sap_hana_ha_loadbalancer_hc.self_link]

  backend {
      group = google_compute_instance_group.sap_hana_ha_primary_instance_group.self_link
  }

  backend {
      group = google_compute_instance_group.sap_hana_ha_secondary_instance_group.self_link
  }

  protocol = "TCP"
  load_balancing_scheme = "INTERNAL"
  failover_policy {
    failover_ratio = 1
    drop_traffic_if_unhealthy = true
    disable_connection_drain_on_failover = true
  }
}

resource "google_compute_health_check" "sap_hana_ha_loadbalancer_hc" {
  name = local.healthcheck_name
  project = var.project_id
  tcp_health_check {
    port = local.sap_hc_port
  }
  check_interval_sec = 10
  healthy_threshold = 2
  timeout_sec = 10
  unhealthy_threshold = 2
}

resource "google_compute_address" "sap_hana_ha_loadbalancer_address" {
  name = local.loadbalancer_address_name
  project = var.project_id
  address_type = "INTERNAL"
  subnetwork = local.subnetwork_uri
  region = local.region
  address = local.loadbalancer_address
}

resource "google_compute_forwarding_rule" "sap_hana_ha_forwarding_rule" {
  name = local.forwardingrule_name
  project = var.project_id
  all_ports = true
  network = local.processed_network
  subnetwork = local.subnetwork_uri
  region = local.region
  backend_service = google_compute_region_backend_service.sap_hana_ha_loadbalancer.id
  load_balancing_scheme = "INTERNAL"
  ip_address = google_compute_address.sap_hana_ha_loadbalancer_address.address
}

resource "google_compute_firewall" "sap_hana_ha_vpc_firewall" {
  count = local.is_vpc_network ? 0 : 1
  name = "${local.healthcheck_name}-allow-firewall-rule"
  project = var.project_id
  network = local.processed_network
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags = ["sap-${local.healthcheck_name}-port"]
  allow {
      protocol = "tcp"
      ports = ["${local.sap_hc_port}"]
  }
}

