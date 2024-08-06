#
# Terraform SAP Max DB for Google Cloud
#
# Version:    DATETIME_OF_BUILD
#

################################################################################
# Local variables
################################################################################
locals {
  zone_split = split("-", var.zone)
  shared_vpc = split("/", var.subnetwork)
  subnetwork = length(local.shared_vpc) > 1 ? (
    "https://www.googleapis.com/compute/v1/projects/${local.shared_vpc[0]}/regions/${local.region}/subnetworks/${local.shared_vpc[1]}") : (
  "https://www.googleapis.com/compute/v1/projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnetwork}")
  region              = "${local.zone_split[0]}-${local.zone_split[1]}"
  max_data_disk_type  = var.maxdb_data_ssd ? "pd-ssd" : "pd-balanced"
  max_log_disk_type   = var.maxdb_log_ssd ? "pd-ssd" : "pd-balanced"
  primary_startup_url = var.sap_deployment_debug ? replace(var.primary_startup_url, "bash -s", "bash -x -s") : var.primary_startup_url
}

################################################################################
# disks
################################################################################
# boot
resource "google_compute_disk" "max_db_boot_disk" {
  name    = "${var.instance_name}-boot"
  type    = "pd-balanced"
  size    = 30 # GB
  zone    = var.zone
  project = var.project_id
  image   = "${var.linux_image_project}/${var.linux_image}"
}

# /sapdb
resource "google_compute_disk" "max_db_root_disk" {
  name    = "${var.instance_name}-maxdbroot"
  type    = "pd-balanced"
  size    = var.maxdb_root_size
  zone    = var.zone
  project = var.project_id
}

# /sapdb/SID/saplog
resource "google_compute_disk" "max_db_log_disk" {
  name    = "${var.instance_name}-maxdblog"
  type    = local.max_log_disk_type
  size    = var.maxdb_log_size
  zone    = var.zone
  project = var.project_id
}

# /sapdb/SID/sapdata
resource "google_compute_disk" "max_db_data_disk" {
  name    = "${var.instance_name}-maxdbdata"
  type    = local.max_data_disk_type
  size    = var.maxdb_data_size
  zone    = var.zone
  project = var.project_id
}

# /maxdbbackup
resource "google_compute_disk" "max_db_backup_disk" {
  name    = "${var.instance_name}-maxdbbackup"
  type    = "pd-balanced"
  size    = var.maxdb_backup_size
  zone    = var.zone
  project = var.project_id
}

# OPTIONAL - /usr/sap
resource "google_compute_disk" "max_db_usr_disk" {
  count   = var.usr_sap_size > 0 ? 1 : 0
  name    = "${var.instance_name}-usrsap"
  type    = "pd-balanced"
  size    = var.usr_sap_size
  zone    = var.zone
  project = var.project_id
}

# OPTIONAL - /sapmnt
resource "google_compute_disk" "max_db_sapmnt" {
  count   = var.sap_mnt_size > 0 ? 1 : 0
  name    = "${var.instance_name}-sapmnt"
  type    = "pd-balanced"
  size    = var.sap_mnt_size
  zone    = var.zone
  project = var.project_id
}

# OPTIONAL - swap disk
resource "google_compute_disk" "max_db_swap" {
  count   = var.swap_size > 0 ? 1 : 0
  name    = "${var.instance_name}-swap"
  type    = "pd-balanced"
  size    = var.swap_size
  zone    = var.zone
  project = var.project_id
}

################################################################################
# instances
################################################################################
resource "google_compute_instance" "sap_maxdb" {
  name             = var.instance_name
  zone             = var.zone
  project          = var.project_id
  machine_type     = var.machine_type
  min_cpu_platform = "Automatic"
  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.max_db_boot_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.max_db_root_disk.name
    source      = google_compute_disk.max_db_root_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.max_db_log_disk.name
    source      = google_compute_disk.max_db_log_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.max_db_data_disk.name
    source      = google_compute_disk.max_db_data_disk.self_link
  }

  attached_disk {
    device_name = google_compute_disk.max_db_backup_disk.name
    source      = google_compute_disk.max_db_backup_disk.self_link
  }

  dynamic "attached_disk" {
    for_each = var.usr_sap_size > 0 ? [1] : []
    content {
      device_name = google_compute_disk.max_db_usr_disk.name
      source      = google_compute_disk.max_db_usr_disk.self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.sap_mnt_size > 0 ? [1] : []
    content {
      device_name = google_compute_disk.max_db_sapmnt.name
      source      = google_compute_disk.max_db_sapmnt.self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.swap_size > 0 ? [1] : []
    content {
      device_name = google_compute_disk.max_db_swap.name
      source      = google_compute_disk.max_db_swap.self_link
    }
  }
  can_ip_forward = var.can_ip_forward
  network_interface {
    subnetwork = local.subnetwork
    # we only include access_config if public_ip is true, an empty access_config
    # will create an ephemeral public ip
    dynamic "access_config" {
      for_each = var.public_ip ? [1] : []
      content {
      }
    }
  }
  tags = var.network_tags
  service_account {
    # An empty string service account will default to the projects default compute engine service account
    email = var.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  dynamic "reservation_affinity" {
    for_each = length(var.reservation_name) > 1 ? [1] : []
    content {
      type = "SPECIFIC_RESERVATION"
      specific_reservation {
        key    = "compute.googleapis.com/reservation-name"
        values = [var.reservation_name]
      }
    }
  }
  metadata = {
    startup-script         = local.primary_startup_url
    post_deployment_script = var.post_deployment_script
    sap_deployment_debug   = var.sap_deployment_debug
    maxdb_sid              = var.maxdb_sid
    template-type          = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}
