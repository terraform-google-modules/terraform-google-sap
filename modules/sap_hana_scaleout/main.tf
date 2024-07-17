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
# Terraform SAP HANA Scaleout for Google Cloud
#
#
# Version:    BUILD.VERSION
# Build Hash: BUILD.HASH
#

################################################################################
# Local variables
################################################################################
locals {
  mem_size_map = {
    "n1-highmem-32"         = 208
    "n1-highmem-64"         = 416
    "n1-highmem-96"         = 624
    "n1-megamem-96"         = 1433
    "n2-highmem-32"         = 256
    "n2-highmem-48"         = 384
    "n2-highmem-64"         = 512
    "n2-highmem-80"         = 640
    "n2-highmem-96"         = 768
    "n2-highmem-128"        = 864
    "n1-ultramem-40"        = 961
    "n1-ultramem-80"        = 1922
    "n1-ultramem-160"       = 3844
    "m1-megamem-96"         = 1433
    "m1-ultramem-40"        = 961
    "m1-ultramem-80"        = 1922
    "m1-ultramem-160"       = 3844
    "m2-ultramem-208"       = 5888
    "m2-megamem-416"        = 5888
    "m2-hypermem-416"       = 8832
    "m2-ultramem-416"       = 11744
    "m3-megamem-64"         = 976
    "m3-megamem-128"        = 1952
    "m3-ultramem-32"        = 976
    "m3-ultramem-64"        = 1952
    "m3-ultramem-128"       = 3904
    "c3-standard-44"        = 176
    "c3-highmem-44"         = 352
    "c3-highmem-88"         = 704
    "c3-highmem-176"        = 1408
    "c3-standard-192-metal" = 768
    "c3-highcpu-192-metal"  = 512
    "c3-highmem-192-metal"  = 1536
    "x4-megamem-960-metal"  = 16384
    "x4-megamem-1440-metal" = 24576
    "x4-megamem-1920-metal" = 32768
  }

  # Default of "Automatic" will be used during instance creation for machine types not listed
  cpu_platform_map = {
    "n1-highmem-32" = "Intel Broadwell"
    "n1-highmem-64" = "Intel Broadwell"
    "n1-highmem-96" = "Intel Skylake"
    "n1-megamem-96" = "Intel Skylake"
    "m1-megamem-96" = "Intel Skylake"
  }

  native_bm = length(regexall("metal", var.machine_type)) > 0
  # Some machine types only support hyperdisks (C4, X4, C3/metal). Depending on the machine type, we default to hyperdisk-extreme or hyperdisk-balanced
  default_hyperdisk_extreme  = (length(regexall("^x4-", var.machine_type)) > 0)
  default_hyperdisk_balanced = (length(regexall("^c4-|^c3-.*-metal", var.machine_type)) > 0)
  only_hyperdisks_supported  = local.default_hyperdisk_extreme || local.default_hyperdisk_balanced

  # Minimum disk sizes are used to ensure throughput. Extreme disks don't need this.
  # All 'over provisioned' capacity is to go onto the data disk.
  final_disk_type = var.disk_type == "" ? (local.default_hyperdisk_extreme ? "hyperdisk-extreme" : (local.default_hyperdisk_balanced ? "hyperdisk-balanced" : "pd-ssd")) : var.disk_type
  min_total_disk_map = {
    "pd-ssd"             = 550
    "pd-balanced"        = 943
    "pd-extreme"         = 0
    "hyperdisk-balanced" = 0
    "hyperdisk-extreme"  = 0
  }

  min_total_disk = local.min_total_disk_map[local.final_disk_type]

  mem_size           = lookup(local.mem_size_map, var.machine_type, 320)
  hana_log_size      = ceil(min(512, max(64, local.mem_size / 2)))
  hana_data_size_min = ceil(local.mem_size * 12 / 10)

  hana_data_size = max(local.hana_data_size_min, local.min_total_disk - local.hana_log_size)
  pd_size        = ceil(max(local.min_total_disk, local.hana_log_size + local.hana_data_size_min + 1))

  unified_pd_size = var.unified_disk_size_override == null ? ceil(local.pd_size) : var.unified_disk_size_override
  data_pd_size    = var.data_disk_size_override == null ? local.hana_data_size : var.data_disk_size_override
  log_pd_size     = var.log_disk_size_override == null ? local.hana_log_size : var.log_disk_size_override

  # Disk types
  final_data_disk_type = var.data_disk_type_override == "" ? local.final_disk_type : var.data_disk_type_override
  final_log_disk_type  = var.log_disk_type_override == "" ? local.final_disk_type : var.log_disk_type_override

  # Disk IOPS
  hdx_iops_map = {
    "data"    = max(10000, local.data_pd_size * 2)
    "log"     = max(10000, local.log_pd_size * 2)
    "shared"  = null
    "usrsap"  = null
    "unified" = max(10000, local.data_pd_size * 2) + max(10000, local.log_pd_size * 2)
    "worker"  = max(10000, local.data_pd_size * 2) + max(10000, local.log_pd_size * 2)
  }
  hdb_iops_map = {
    "data"    = var.hyperdisk_balanced_iops_default
    "log"     = var.hyperdisk_balanced_iops_default
    "shared"  = null
    "usrsap"  = null
    "unified" = var.hyperdisk_balanced_iops_default
    "worker"  = var.hyperdisk_balanced_iops_default
  }
  null_iops_map = {
    "data"    = null
    "log"     = null
    "shared"  = null
    "usrsap"  = null
    "unified" = null
    "worker"  = null
  }
  iops_map = {
    "pd-ssd"             = local.null_iops_map
    "pd-balanced"        = local.null_iops_map
    "pd-extreme"         = local.hdx_iops_map
    "hyperdisk-balanced" = local.hdb_iops_map
    "hyperdisk-extreme"  = local.hdx_iops_map
  }

  final_data_iops    = var.data_disk_iops_override == null ? local.iops_map[local.final_data_disk_type]["data"] : var.data_disk_iops_override
  final_log_iops     = var.log_disk_iops_override == null ? local.iops_map[local.final_log_disk_type]["log"] : var.log_disk_iops_override
  final_unified_iops = var.unified_disk_iops_override == null ? local.iops_map[local.final_disk_type]["unified"] : var.unified_disk_iops_override

  # Disk throughput MB/s
  hdb_throughput_map = {
    "data"    = var.hyperdisk_balanced_throughput_default
    "log"     = var.hyperdisk_balanced_throughput_default
    "unified" = var.hyperdisk_balanced_throughput_default
  }
  null_throughput_map = {
    "data"    = null
    "log"     = null
    "unified" = null
  }
  throughput_map = {
    "pd-ssd"             = local.null_throughput_map
    "pd-balanced"        = local.null_throughput_map
    "pd-extreme"         = local.null_throughput_map
    "hyperdisk-balanced" = local.hdb_throughput_map
    "hyperdisk-extreme"  = local.null_throughput_map
  }

  final_data_throughput    = var.data_disk_throughput_override == null ? local.throughput_map[local.final_data_disk_type]["data"] : var.data_disk_throughput_override
  final_log_throughput     = var.log_disk_throughput_override == null ? local.throughput_map[local.final_log_disk_type]["log"] : var.log_disk_throughput_override
  final_unified_throughput = var.unified_disk_throughput_override == null ? local.throughput_map[local.final_disk_type]["unified"] : var.unified_disk_throughput_override

  primary_startup_url   = var.sap_deployment_debug ? replace(var.primary_startup_url, "bash -s", "bash -x -s") : var.primary_startup_url
  secondary_startup_url = var.sap_deployment_debug ? replace(var.secondary_startup_url, "bash -s", "bash -x -s") : var.secondary_startup_url

  zone_split       = split("-", var.zone)
  region           = "${local.zone_split[0]}-${local.zone_split[1]}"
  subnetwork_split = split("/", var.subnetwork)
  subnetwork_uri = length(local.subnetwork_split) > 1 ? (
    "projects/${local.subnetwork_split[0]}/regions/${local.region}/subnetworks/${local.subnetwork_split[1]}") : (
  "projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnetwork}")
}

# tflint-ignore: terraform_unused_declarations
data "assert_test" "verify_hyperdisk_usage" {
  test  = local.only_hyperdisks_supported ? length(regexall("hyperdisk", local.final_disk_type)) > 0 : true
  throw = "The selected a machine type only works with hyperdisks. Set 'disk_type' accordingly, e.g. 'disk_type = hyperdisk-balanced'"
}


################################################################################
# disks
################################################################################
resource "google_compute_disk" "sap_hana_scaleout_boot_disks" {
  # Need a disk for primary, worker nodes, standby nodes
  count   = var.sap_hana_worker_nodes + var.sap_hana_standby_nodes + 1
  name    = count.index == 0 ? "${var.instance_name}-boot" : "${var.instance_name}w${count.index}-boot"
  type    = local.only_hyperdisks_supported ? "hyperdisk-balanced" : "pd-balanced"
  zone    = var.zone
  size    = 45
  project = var.project_id
  image   = "${var.linux_image_project}/${var.linux_image}"

  lifecycle {
    # Ignores newer versions of the OS image. Removing this lifecycle
    # and re-applying will cause the current disk to be deleted.
    # All existing data will be lost.
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "sap_hana_scaleout_disks" {
  # Need a pd disk for primary, worker nodes
  count                  = var.use_single_data_log_disk ? var.sap_hana_worker_nodes + 1 : 0
  name                   = format("${var.instance_name}-hana%05d", count.index + 1)
  type                   = local.final_disk_type
  zone                   = var.zone
  size                   = local.unified_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_unified_iops
  provisioned_throughput = local.final_unified_throughput
}

resource "google_compute_disk" "sap_hana_data_disks" {
  count                  = var.use_single_data_log_disk ? 0 : var.sap_hana_worker_nodes + 1
  name                   = format("${var.instance_name}-data%05d", count.index + 1)
  type                   = local.final_data_disk_type
  zone                   = var.zone
  size                   = local.data_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_data_iops
  provisioned_throughput = local.final_data_throughput
}

resource "google_compute_disk" "sap_hana_log_disks" {
  count                  = var.use_single_data_log_disk ? 0 : var.sap_hana_worker_nodes + 1
  name                   = format("${var.instance_name}-log%05d", count.index + 1)
  type                   = local.final_log_disk_type
  zone                   = var.zone
  size                   = local.log_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_log_iops
  provisioned_throughput = local.final_log_throughput
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
  address      = var.vm_static_ip
}
resource "google_compute_address" "sap_hana_worker_ip" {
  count        = var.sap_hana_worker_nodes
  name         = "${var.instance_name}w-${count.index + 1}"
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
  address      = length(var.worker_static_ips) > count.index ? var.worker_static_ips[count.index] : ""
}
resource "google_compute_address" "sap_hana_standby_ip" {
  count        = var.sap_hana_standby_nodes
  name         = "${var.instance_name}s-${count.index + var.sap_hana_worker_nodes + 1}"
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
  address      = length(var.standby_static_ips) > count.index ? var.standby_static_ips[count.index] : ""
}

################################################################################
# instances
################################################################################
resource "google_compute_instance" "sap_hana_scaleout_primary_instance" {
  # We will have a primary, worker nodes, and standby nodes
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.sap_hana_scaleout_boot_disks[0].self_link
  }

  dynamic "scheduling" {
    for_each = local.native_bm ? [1] : []
    content {
      on_host_maintenance = "TERMINATE"
    }
  }

  dynamic "attached_disk" {
    for_each = var.use_single_data_log_disk ? [1] : []
    content {
      device_name = google_compute_disk.sap_hana_scaleout_disks[0].name
      source      = google_compute_disk.sap_hana_scaleout_disks[0].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_data_log_disk ? [] : [1]
    content {
      device_name = google_compute_disk.sap_hana_data_disks[0].name
      source      = google_compute_disk.sap_hana_data_disks[0].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_data_log_disk ? [] : [1]
    content {
      device_name = google_compute_disk.sap_hana_log_disks[0].name
      source      = google_compute_disk.sap_hana_log_disks[0].self_link
    }
  }
  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_vm_ip.address
    nic_type   = var.nic_type == "" ? null : var.nic_type

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
    # The default empty service account string will use the projects default compute engine service account
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
    sap_hana_original_role          = "master"
    sap_hana_sid                    = var.sap_hana_sid
    sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
    sap_hana_instance_number        = var.sap_hana_instance_number
    sap_hana_sidadm_password        = var.sap_hana_sidadm_password
    sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_scaleout_nodes         = var.sap_hana_worker_nodes + var.sap_hana_standby_nodes
    sap_hana_worker_nodes           = var.sap_hana_worker_nodes
    sap_hana_standby_nodes          = var.sap_hana_standby_nodes
    sap_hana_shared_nfs             = var.sap_hana_shared_nfs
    sap_hana_backup_nfs             = var.sap_hana_backup_nfs
    use_single_data_log_disk        = var.use_single_data_log_disk
    sap_hana_data_disk_type         = local.final_data_disk_type
    native_bm                       = local.native_bm
    template-type                   = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}

resource "google_compute_instance" "sap_hana_scaleout_worker_instances" {
  # We will have a primary, worker nodes, and standby nodes
  count        = var.sap_hana_worker_nodes
  name         = "${var.instance_name}w${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.sap_hana_scaleout_boot_disks[count.index + 1].self_link
  }

  dynamic "scheduling" {
    for_each = local.native_bm ? [1] : []
    content {
      on_host_maintenance = "TERMINATE"
    }
  }

  dynamic "attached_disk" {
    for_each = var.use_single_data_log_disk ? [1] : []
    content {
      device_name = google_compute_disk.sap_hana_scaleout_disks[count.index + 1].name
      source      = google_compute_disk.sap_hana_scaleout_disks[count.index + 1].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_data_log_disk ? [] : [1]
    content {
      device_name = google_compute_disk.sap_hana_data_disks[count.index + 1].name
      source      = google_compute_disk.sap_hana_data_disks[count.index + 1].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_data_log_disk ? [] : [1]
    content {
      device_name = google_compute_disk.sap_hana_log_disks[count.index + 1].name
      source      = google_compute_disk.sap_hana_log_disks[count.index + 1].self_link
    }
  }
  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_worker_ip[count.index].address
    nic_type   = var.nic_type == "" ? null : var.nic_type
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
    startup-script             = local.secondary_startup_url
    post_deployment_script     = var.post_deployment_script
    sap_deployment_debug       = var.sap_deployment_debug
    sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
    sap_hana_sid               = var.sap_hana_sid
    sap_hana_sapsys_gid        = var.sap_hana_sapsys_gid
    sap_hana_instance_number   = var.sap_hana_instance_number
    sap_hana_scaleout_nodes    = var.sap_hana_worker_nodes + var.sap_hana_standby_nodes

    sap_hana_original_role          = "worker"
    sap_hana_sidadm_password        = var.sap_hana_sidadm_password
    sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_shared_nfs             = var.sap_hana_shared_nfs
    sap_hana_backup_nfs             = var.sap_hana_backup_nfs
    sap_hana_worker_nodes           = var.sap_hana_worker_nodes
    sap_hana_standby_nodes          = var.sap_hana_standby_nodes
    use_single_data_log_disk        = var.use_single_data_log_disk
    native_bm                       = local.native_bm
    template-type                   = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }

  depends_on = [
    google_compute_instance.sap_hana_scaleout_primary_instance,
  ]
}

resource "google_compute_instance" "sap_hana_scaleout_standby_instances" {
  # We will have a primary, worker nodes, and standby nodes
  count        = var.sap_hana_standby_nodes
  name         = "${var.instance_name}w${count.index + var.sap_hana_worker_nodes + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id

  min_cpu_platform = lookup(local.cpu_platform_map, var.machine_type, "Automatic")

  boot_disk {
    auto_delete = true
    device_name = "boot"
    source      = google_compute_disk.sap_hana_scaleout_boot_disks[count.index + var.sap_hana_worker_nodes + 1].self_link
  }

  dynamic "scheduling" {
    for_each = local.native_bm ? [1] : []
    content {
      on_host_maintenance = "TERMINATE"
    }
  }

  can_ip_forward = var.can_ip_forward

  network_interface {
    subnetwork = local.subnetwork_uri
    network_ip = google_compute_address.sap_hana_standby_ip[count.index].address
    nic_type   = var.nic_type == "" ? null : var.nic_type
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
    startup-script             = local.secondary_startup_url
    post_deployment_script     = var.post_deployment_script
    sap_deployment_debug       = var.sap_deployment_debug
    sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
    sap_hana_sid               = var.sap_hana_sid
    sap_hana_sapsys_gid        = var.sap_hana_sapsys_gid
    sap_hana_instance_number   = var.sap_hana_instance_number
    sap_hana_scaleout_nodes    = var.sap_hana_worker_nodes + var.sap_hana_standby_nodes

    sap_hana_original_role          = "standby"
    sap_hana_sidadm_password        = var.sap_hana_sidadm_password
    sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
    sap_hana_shared_nfs             = var.sap_hana_shared_nfs
    sap_hana_backup_nfs             = var.sap_hana_backup_nfs
    sap_hana_worker_nodes           = var.sap_hana_worker_nodes
    sap_hana_standby_nodes          = var.sap_hana_standby_nodes
    native_bm                       = local.native_bm
    template-type                   = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }

  depends_on = [
    google_compute_instance.sap_hana_scaleout_primary_instance,
  ]
}
