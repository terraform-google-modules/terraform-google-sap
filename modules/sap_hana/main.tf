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
# Terraform SAP HANA for Google Cloud
#
# Version:    2.0.2022112119581669060735
# Build Hash: 8fa5ae64ac323505b8c8efcd585d65afd762bb3e
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
    "m3-megamem-64"   = 976
    "m3-megamem-128"  = 1952
    "m3-ultramem-32"  = 976
    "m3-ultramem-64"  = 1952
    "m3-ultramem-128" = 3904
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
    "m3-megamem-64"   = "Automatic"
    "m3-megamem-128"  = "Automatic"
    "m3-ultramem-32"  = "Automatic"
    "m3-ultramem-64"  = "Automatic"
    "m3-ultramem-128" = "Automatic"
  }
  mem_size             = lookup(local.mem_size_map, var.machine_type, 320)
  hana_log_size_min    = min(512, max(64, local.mem_size / 2))
  hana_data_size_min   = local.mem_size * 12 / 10
  hana_shared_size_min = min(1024, local.mem_size)

  hana_log_size  = local.hana_log_size_min
  hana_data_size = local.hana_data_size_min

  # scaleout_nodes > 0 then hana_shared_size and pdhdd is changed; assumes that sap_hana_scaleout_nodes is an interger
  hana_shared_size   = local.hana_shared_size_min * (var.sap_hana_scaleout_nodes > 0 ? ceil(var.sap_hana_scaleout_nodes / 4) : 1)
  pdhdd_size_default = var.sap_hana_scaleout_nodes > 0 ? 2 * local.mem_size * (var.sap_hana_scaleout_nodes + 1) : 0

  # ensure pd-ssd meets minimum size/performance ; 32 is the min allowed memery and + 1 is there to make sure no undersizing happens
  pdssd_size = ceil(max(834, local.hana_log_size + local.hana_data_size + local.hana_shared_size + 32 + 1))

  # ensure pd-hdd for backup is smaller than the maximum pd size
  pdssd_size_worker = ceil(max(834, local.hana_log_size + local.hana_data_size + 32 + 1))

  # change PD-HDD size if a custom backup size has been set
  pdhdd_size = var.sap_hana_backup_size > 0 ? var.sap_hana_backup_size : local.pdhdd_size_default

  # network config variables
  zone_split       = split("-", var.zone)
  region           = "${local.zone_split[0]}-${local.zone_split[1]}"
  subnetwork_split = split("/", var.subnetwork)
  subnetwork_uri = length(local.subnetwork_split) > 1 ? (
    "projects/${local.subnetwork_split[0]}/regions/${local.region}/subnetworks/${local.subnetwork_split[1]}") : (
  "projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnetwork}")
  primary_startup_url   = var.sap_deployment_debug ? replace(var.primary_startup_url, "bash -s", "bash -x -s") : var.primary_startup_url
  secondary_startup_url = var.sap_deployment_debug ? replace(var.secondary_startup_url, "bash -s", "bash -x -s") : var.secondary_startup_url
}

################################################################################
# disks
################################################################################

resource "google_compute_disk" "sap_hana_boot_disks" {
  count   = var.sap_hana_scaleout_nodes + 1
  name    = format("${var.instance_name}-boot%05d", count.index + 1)
  type    = "pd-standard"
  zone    = var.zone
  size    = 30 # GB
  project = var.project_id
  image   = "${var.linux_image_project}/${var.linux_image}"

  lifecycle {
    # Ignores newer versions of the OS image. Removing this lifecycle
    # and re-applying will cause the current disk to be deleted.
    # All existing data will be lost.
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "sap_hana_pdssd_disks" {
  count = var.sap_hana_scaleout_nodes + 1
  # TODO(b/202736714): check if name is correct
  name    = format("${var.instance_name}-pdssd%05d", count.index + 1)
  type    = "pd-ssd"
  zone    = var.zone
  size    = local.pdssd_size
  project = var.project_id
}
resource "google_compute_disk" "sap_hana_backup_disk" {
  # TODO(b/202736714): check if name is correct
  name    = "${var.instance_name}-backup"
  type    = "pd-standard"
  zone    = var.zone
  size    = local.pdhdd_size
  project = var.project_id
}

################################################################################
# VIPs
################################################################################

resource "google_compute_address" "sap_hana_vm_ip" {
  name         = var.instance_name
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
}

resource "google_compute_address" "sap_hana_worker_ip" {
  count        = var.sap_hana_scaleout_nodes
  name         = "${var.instance_name}w-${1 + count.index}"
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
}

################################################################################
# instances
################################################################################
resource "google_compute_instance" "sap_hana_primary_instance" {
  name             = var.instance_name
  machine_type     = var.machine_type
  zone             = var.zone
  project          = var.project_id
  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.sap_hana_boot_disks[0].self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_pdssd_disks[0].name
    source      = google_compute_disk.sap_hana_pdssd_disks[0].self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_backup_disk.name
    source      = google_compute_disk.sap_hana_backup_disk.self_link
  }

  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_vm_ip.address
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
    startup-script                  = local.primary_startup_url
    post_deployment_script          = var.post_deployment_script
    sap_deployment_debug            = var.sap_deployment_debug
    sap_hana_deployment_bucket      = var.sap_hana_deployment_bucket
    sap_hana_sid                    = var.sap_hana_sid
    sap_hana_instance_number        = var.sap_hana_instance_number
    sap_hana_sidadm_password        = var.sap_hana_sidadm_password
    sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
    # wording on system_password may be inconsitent with DM
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
    sap_hana_scaleout_nodes         = var.sap_hana_scaleout_nodes
    template-type                   = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}

# creates additional workers
resource "google_compute_instance" "sap_hana_worker_instances" {
  count            = var.sap_hana_scaleout_nodes
  name             = "${var.instance_name}w${count.index + 1}"
  machine_type     = var.machine_type
  zone             = var.zone
  project          = var.project_id
  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.sap_hana_boot_disks[count.index + 1].self_link
  }

  attached_disk {
    device_name = google_compute_disk.sap_hana_pdssd_disks[count.index + 1].name
    source      = google_compute_disk.sap_hana_pdssd_disks[count.index + 1].self_link
  }

  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_worker_ip[count.index].address
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
    startup-script                  = local.secondary_startup_url
    post_deployment_script          = var.post_deployment_script
    sap_deployment_debug            = var.sap_deployment_debug
    sap_hana_deployment_bucket      = var.sap_hana_deployment_bucket
    sap_hana_sid                    = var.sap_hana_sid
    sap_hana_instance_number        = var.sap_hana_instance_number
    sap_hana_sidadm_password        = var.sap_hana_sidadm_password
    sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
    # wording on system_password may be inconsitent with DM
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
    sap_hana_scaleout_nodes         = var.sap_hana_scaleout_nodes
    template-type                   = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}
