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
# Version:    DATETIME_OF_BUILD
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
    "c4-highmem- 32"        = 248
    "c4-highmem-48"         = 372
    "c4-highmem-96"         = 744
    "c4-highmem-192"        = 1488
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
  num_data_disks             = var.enable_data_striping ? var.number_data_disks : 1
  num_log_disks              = var.enable_log_striping ? var.number_log_disks : 1

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

  mem_size             = lookup(local.mem_size_map, var.machine_type, 320)
  hana_log_size        = ceil(min(512, max(64, local.mem_size / 2)))
  hana_data_size_min   = ceil(local.mem_size * 12 / 10)
  hana_shared_size_min = min(1024, local.mem_size)
  hana_usrsap_size     = 32

  hana_data_size = max(local.hana_data_size_min, local.min_total_disk - local.hana_usrsap_size - local.hana_log_size - local.hana_shared_size_min)

  # scaleout_nodes > 0 then hana_shared_size and backup is changed; assumes that sap_hana_scaleout_nodes is an integer
  hana_shared_size = var.sap_hana_scaleout_nodes > 0 ? local.hana_shared_size_min * ceil(var.sap_hana_scaleout_nodes / 4) : local.hana_shared_size_min
  backup_size      = var.sap_hana_backup_size > 0 ? var.sap_hana_backup_size : 2 * local.mem_size * (var.sap_hana_scaleout_nodes + 1)

  # ensure the combined disk meets minimum size/performance ;
  pd_size = ceil(max(local.min_total_disk, local.hana_log_size + local.hana_data_size_min + local.hana_shared_size + local.hana_usrsap_size + 1))

  # ensure pd-hdd for backup is smaller than the maximum pd size
  pd_size_worker = ceil(max(local.min_total_disk, local.hana_log_size + local.hana_data_size_min + local.hana_usrsap_size + 1))

  unified_pd_size        = var.unified_disk_size_override == null ? local.pd_size : var.unified_disk_size_override
  unified_worker_pd_size = var.unified_worker_disk_size_override == null ? local.pd_size_worker : var.unified_worker_disk_size_override
  # for striping: divide data/log size by number of disks
  data_pd_size   = var.data_disk_size_override == null ? ceil(local.hana_data_size / local.num_data_disks) : ceil(var.data_disk_size_override / local.num_data_disks)
  log_pd_size    = var.log_disk_size_override == null ? ceil(local.hana_log_size / local.num_log_disks) : ceil(var.log_disk_size_override / local.num_log_disks)
  shared_pd_size = var.shared_disk_size_override == null ? local.hana_shared_size : var.shared_disk_size_override
  usrsap_pd_size = var.usrsap_disk_size_override == null ? local.hana_usrsap_size : var.usrsap_disk_size_override

  # Disk types
  final_data_disk_type   = var.data_disk_type_override == "" ? local.final_disk_type : var.data_disk_type_override
  final_log_disk_type    = var.log_disk_type_override == "" ? local.final_disk_type : var.log_disk_type_override
  temp_shared_disk_type  = local.only_hyperdisks_supported ? "hyperdisk-balanced" : (contains(["hyperdisk-extreme", "hyperdisk-balanced", "pd-extreme"], local.final_disk_type) ? "pd-balanced" : local.final_disk_type)
  temp_usrsap_disk_type  = local.only_hyperdisks_supported ? "hyperdisk-balanced" : (contains(["hyperdisk-extreme", "hyperdisk-balanced", "pd-extreme"], local.final_disk_type) ? "pd-balanced" : local.final_disk_type)
  final_shared_disk_type = var.shared_disk_type_override == "" ? local.temp_shared_disk_type : var.shared_disk_type_override
  final_usrsap_disk_type = var.usrsap_disk_type_override == "" ? local.temp_usrsap_disk_type : var.usrsap_disk_type_override
  final_backup_disk_type = var.backup_disk_type == "" ? (local.only_hyperdisks_supported ? "hyperdisk-balanced" : "pd-balanced") : var.backup_disk_type

  # Disk IOPS
  hdx_iops_map = {
    "data"    = max(10000, local.data_pd_size * 2 * local.num_data_disks)
    "log"     = max(10000, local.log_pd_size * 2 * local.num_log_disks)
    "shared"  = null
    "usrsap"  = null
    "unified" = max(10000, local.data_pd_size * 2 * local.num_data_disks) + max(10000, local.log_pd_size * 2 * local.num_log_disks)
    "worker"  = max(10000, local.data_pd_size * 2 * local.num_data_disks) + max(10000, local.log_pd_size * 2 * local.num_log_disks)
    "backup"  = max(10000, 2 * local.backup_size)
  }
  hdb_iops_map = {
    "data"    = var.hyperdisk_balanced_iops_default
    "log"     = var.hyperdisk_balanced_iops_default
    "shared"  = null
    "usrsap"  = null
    "unified" = var.hyperdisk_balanced_iops_default
    "worker"  = var.hyperdisk_balanced_iops_default
    "backup"  = var.hyperdisk_balanced_iops_default
  }
  null_iops_map = {
    "data"    = null
    "log"     = null
    "shared"  = null
    "usrsap"  = null
    "unified" = null
    "worker"  = null
    "backup"  = null
  }
  iops_map = {
    "pd-ssd"             = local.null_iops_map
    "pd-balanced"        = local.null_iops_map
    "pd-extreme"         = local.hdx_iops_map
    "hyperdisk-balanced" = local.hdb_iops_map
    "hyperdisk-extreme"  = local.hdx_iops_map
  }

  # for striping: divide data/log IOPS by number of disks
  final_data_iops = (var.data_disk_iops_override == null ?
    (local.iops_map[local.final_data_disk_type]["data"] == null ? null : ceil(local.iops_map[local.final_data_disk_type]["data"] / local.num_data_disks)
  ) : ceil(var.data_disk_iops_override / local.num_data_disks))
  final_log_iops = (var.log_disk_iops_override == null ?
    (local.iops_map[local.final_log_disk_type]["log"] == null ? null : ceil(local.iops_map[local.final_log_disk_type]["log"] / local.num_log_disks)
  ) : ceil(var.log_disk_iops_override / local.num_log_disks))
  final_shared_iops         = var.shared_disk_iops_override == null ? local.iops_map[local.final_shared_disk_type]["shared"] : var.shared_disk_iops_override
  final_usrsap_iops         = var.usrsap_disk_iops_override == null ? local.iops_map[local.final_usrsap_disk_type]["usrsap"] : var.usrsap_disk_iops_override
  final_unified_iops        = var.unified_disk_iops_override == null ? local.iops_map[local.final_disk_type]["unified"] : var.unified_disk_iops_override
  final_unified_worker_iops = var.unified_worker_disk_iops_override == null ? local.iops_map[local.final_disk_type]["worker"] : var.unified_worker_disk_iops_override
  final_backup_iops         = var.backup_disk_iops_override == null ? local.iops_map[local.final_backup_disk_type]["backup"] : var.backup_disk_iops_override

  # Disk throughput MB/s
  hdb_throughput_map = {
    "data"    = var.hyperdisk_balanced_throughput_default
    "log"     = var.hyperdisk_balanced_throughput_default
    "shared"  = null
    "usrsap"  = null
    "unified" = var.hyperdisk_balanced_throughput_default
    "worker"  = var.hyperdisk_balanced_throughput_default
    "backup"  = var.hyperdisk_balanced_throughput_default
  }
  null_throughput_map = {
    "data"    = null
    "log"     = null
    "shared"  = null
    "usrsap"  = null
    "unified" = null
    "worker"  = null
    "backup"  = null
  }
  throughput_map = {
    "pd-ssd"             = local.null_throughput_map
    "pd-balanced"        = local.null_throughput_map
    "pd-extreme"         = local.null_throughput_map
    "hyperdisk-balanced" = local.hdb_throughput_map
    "hyperdisk-extreme"  = local.null_throughput_map
  }

  # for striping: divide throughput by number of disks
  final_data_throughput = (var.data_disk_throughput_override == null ?
    (local.throughput_map[local.final_data_disk_type]["data"] == null ? null : ceil(local.throughput_map[local.final_data_disk_type]["data"] / local.num_data_disks)
  ) : ceil(var.data_disk_throughput_override / local.num_data_disks))
  final_log_throughput = (var.log_disk_throughput_override == null ?
    (local.throughput_map[local.final_log_disk_type]["log"] == null ? null : ceil(local.throughput_map[local.final_log_disk_type]["log"] / local.num_log_disks)
  ) : ceil(var.log_disk_throughput_override / local.num_log_disks))
  final_shared_throughput         = var.shared_disk_throughput_override == null ? local.throughput_map[local.final_shared_disk_type]["shared"] : var.shared_disk_throughput_override
  final_usrsap_throughput         = var.usrsap_disk_throughput_override == null ? local.throughput_map[local.final_usrsap_disk_type]["usrsap"] : var.usrsap_disk_throughput_override
  final_unified_throughput        = var.unified_disk_throughput_override == null ? local.throughput_map[local.final_disk_type]["unified"] : var.unified_disk_throughput_override
  final_unified_worker_throughput = var.unified_worker_disk_throughput_override == null ? local.throughput_map[local.final_disk_type]["worker"] : var.unified_worker_disk_throughput_override
  final_backup_throughput         = var.backup_disk_throughput_override == null ? local.throughput_map[local.final_backup_disk_type]["backup"] : var.backup_disk_throughput_override

  # network config variables
  zone_split       = split("-", var.zone)
  region           = "${local.zone_split[0]}-${local.zone_split[1]}"
  subnetwork_split = split("/", var.subnetwork)
  subnetwork_uri = length(local.subnetwork_split) > 1 ? (
    "projects/${local.subnetwork_split[0]}/regions/${local.region}/subnetworks/${local.subnetwork_split[1]}") : (
  "projects/${var.project_id}/regions/${local.region}/subnetworks/${var.subnetwork}")
  primary_startup_url   = var.sap_deployment_debug ? replace(var.primary_startup_url, "bash -s", "bash -x -s") : var.primary_startup_url
  secondary_startup_url = var.sap_deployment_debug ? replace(var.secondary_startup_url, "bash -s", "bash -x -s") : var.secondary_startup_url

  has_shared_nfs   = !(var.sap_hana_shared_nfs == "" && var.sap_hana_shared_nfs_resource == null)
  make_shared_disk = !var.use_single_shared_data_log_disk && !local.has_shared_nfs

  use_backup_disk = (var.include_backup_disk && var.sap_hana_backup_nfs == "" && var.sap_hana_backup_nfs_resource == null)

  both_backup_nfs_defined = (var.sap_hana_backup_nfs != "") && var.sap_hana_backup_nfs_resource != null
  both_shared_nfs_defined = (var.sap_hana_shared_nfs != "") && var.sap_hana_shared_nfs_resource != null

  backup_nfs_endpoint = var.sap_hana_backup_nfs_resource == null ? var.sap_hana_backup_nfs : "${var.sap_hana_backup_nfs_resource.networks[0].ip_addresses[0]}:/${var.sap_hana_backup_nfs_resource.file_shares[0].name}"
  shared_nfs_endpoint = var.sap_hana_shared_nfs_resource == null ? var.sap_hana_shared_nfs : "${var.sap_hana_shared_nfs_resource.networks[0].ip_addresses[0]}:/${var.sap_hana_shared_nfs_resource.file_shares[0].name}"

}

# tflint-ignore: terraform_unused_declarations
data "assert_test" "one_backup" {
  test  = local.use_backup_disk || !local.both_backup_nfs_defined
  throw = "Either use a disk for /backup (include_backup_disk) or use NFS. If using an NFS as /backup then only either sap_hana_backup_nfs or sap_hana_backup_nfs_resource may be defined."
}
# tflint-ignore: terraform_unused_declarations
data "assert_test" "one_shared" {
  test  = !local.both_shared_nfs_defined
  throw = "If using an NFS as /shared then only either sap_hana_shared_nfs or sap_hana_shared_nfs_resource may be defined."
}
# tflint-ignore: terraform_unused_declarations
data "assert_test" "both_or_neither_nfs" {
  test  = (local.backup_nfs_endpoint == "") == (local.shared_nfs_endpoint == "")
  throw = "If either NFS is defined, then both /shared and /backup must be defined."
}
# tflint-ignore: terraform_unused_declarations
data "assert_test" "verify_hyperdisk_usage" {
  test  = local.only_hyperdisks_supported ? length(regexall("hyperdisk", local.final_disk_type)) > 0 : true
  throw = "The selected machine type only works with hyperdisks. Set 'disk_type' accordingly, e.g. 'disk_type = hyperdisk-balanced'"
}
# tflint-ignore: terraform_unused_declarations
data "assert_test" "verify_hyperdisk_usage_for_backup_disk" {
  test  = local.only_hyperdisks_supported && local.use_backup_disk ? (length(regexall("hyperdisk", local.final_backup_disk_type)) > 0) : true
  throw = "The selected machine type only works with hyperdisks. Set 'backup_disk_type' accordingly, e.g. 'backup_disk_type = hyperdisk-balanced'"
}
# tflint-ignore: terraform_unused_declarations
data "assert_test" "striping_with_split_disk" {
  test  = ((var.enable_data_striping || var.enable_log_striping) && !var.use_single_shared_data_log_disk) || !(var.enable_data_striping || var.enable_log_striping)
  throw = "Striping not supported if log and data are on the same disk(s). To use striping set 'use_single_shared_data_log_disk=false'"
}
# tflint-ignore: terraform_unused_declarations
data "validation_warning" "warn_data_striping" {
  condition = var.enable_data_striping
  summary   = "Data striping is only intended for cases where the machine level limits are higher than the hyperdisk disk level limits. Refer to https://cloud.google.com/compute/docs/disks/hyperdisks#hd-performance-limits"
}
# tflint-ignore: terraform_unused_declarations
data "validation_warning" "warn_log_striping" {
  condition = var.enable_log_striping
  summary   = "Log striping is not a recommended deployment option."
}

################################################################################
# disks
################################################################################

resource "google_compute_disk" "sap_hana_boot_disks" {
  count   = var.sap_hana_scaleout_nodes + 1
  name    = format("${var.instance_name}-boot%05d", count.index + 1)
  type    = local.only_hyperdisks_supported ? "hyperdisk-balanced" : "pd-balanced"
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

resource "google_compute_disk" "sap_hana_unified_disks" {
  count                  = var.use_single_shared_data_log_disk ? 1 : 0
  name                   = format("${var.instance_name}-hana")
  type                   = local.final_disk_type
  zone                   = var.zone
  size                   = local.unified_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_unified_iops
  provisioned_throughput = local.final_unified_throughput
}
resource "google_compute_disk" "sap_hana_unified_worker_disks" {
  count                  = var.use_single_shared_data_log_disk ? var.sap_hana_scaleout_nodes : 0
  name                   = format("${var.instance_name}-hana%05d", count.index + 1)
  type                   = local.final_disk_type
  zone                   = var.zone
  size                   = local.unified_worker_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_unified_worker_iops
  provisioned_throughput = local.final_unified_worker_throughput
}

# Split data/log/sap disks
#  name without striping:  00001, 00002, ...
#  name with striping: 00001-01, 00001-02, 00001-03, 00002-01, 00002-02, 00002-03, ...
resource "google_compute_disk" "sap_hana_data_disks" {
  count = var.use_single_shared_data_log_disk ? 0 : (var.sap_hana_scaleout_nodes + 1) * local.num_data_disks
  name = (var.enable_data_striping ?
    format("${var.instance_name}-data%05d-%02d", floor(count.index / local.num_data_disks) + 1, (count.index % local.num_data_disks) + 1) :
  format("${var.instance_name}-data%05d", count.index + 1))
  type                   = local.final_data_disk_type
  zone                   = var.zone
  size                   = local.data_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_data_iops
  provisioned_throughput = local.final_data_throughput
}
resource "google_compute_disk" "sap_hana_log_disks" {
  count = var.use_single_shared_data_log_disk ? 0 : (var.sap_hana_scaleout_nodes + 1) * local.num_log_disks
  name = (var.enable_log_striping ?
    format("${var.instance_name}-log%05d-%02d", floor(count.index / local.num_log_disks) + 1, (count.index % local.num_log_disks) + 1) :
  format("${var.instance_name}-log%05d", count.index + 1))
  type                   = local.final_log_disk_type
  zone                   = var.zone
  size                   = local.log_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_log_iops
  provisioned_throughput = local.final_log_throughput
}
resource "google_compute_disk" "sap_hana_shared_disk" {
  count                  = local.make_shared_disk ? 1 : 0
  name                   = format("${var.instance_name}-shared%05d", count.index + 1)
  type                   = local.final_shared_disk_type
  zone                   = var.zone
  size                   = local.shared_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_shared_iops
  provisioned_throughput = local.final_shared_throughput
}
resource "google_compute_disk" "sap_hana_usrsap_disks" {
  count                  = var.use_single_shared_data_log_disk ? 0 : var.sap_hana_scaleout_nodes + 1
  name                   = format("${var.instance_name}-usrsap%05d", count.index + 1)
  type                   = local.final_usrsap_disk_type
  zone                   = var.zone
  size                   = local.usrsap_pd_size
  project                = var.project_id
  provisioned_iops       = local.final_usrsap_iops
  provisioned_throughput = local.final_usrsap_throughput
}


resource "google_compute_disk" "sap_hana_backup_disk" {
  count                  = local.use_backup_disk ? 1 : 0
  name                   = "${var.instance_name}-backup"
  type                   = local.final_backup_disk_type
  zone                   = var.zone
  size                   = local.backup_size
  project                = var.project_id
  provisioned_iops       = local.final_backup_iops
  provisioned_throughput = local.final_backup_throughput
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
  count        = var.sap_hana_scaleout_nodes
  name         = "${var.instance_name}w-${1 + count.index}"
  subnetwork   = local.subnetwork_uri
  address_type = "INTERNAL"
  region       = local.region
  project      = var.project_id
  address      = length(var.worker_static_ips) > count.index ? var.worker_static_ips[count.index] : ""
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

  dynamic "scheduling" {
    for_each = local.native_bm ? [1] : []
    content {
      on_host_maintenance = "TERMINATE"
    }
  }

  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [1] : []
    content {
      device_name = google_compute_disk.sap_hana_unified_disks[0].name
      source      = google_compute_disk.sap_hana_unified_disks[0].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [] : [for i in range(local.num_data_disks) : {
      final_disk_index = i
    }]
    content {
      device_name = google_compute_disk.sap_hana_data_disks[attached_disk.value.final_disk_index].name
      source      = google_compute_disk.sap_hana_data_disks[attached_disk.value.final_disk_index].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [] : [for i in range(local.num_log_disks) : {
      final_disk_index = i
    }]
    content {
      device_name = google_compute_disk.sap_hana_log_disks[attached_disk.value.final_disk_index].name
      source      = google_compute_disk.sap_hana_log_disks[attached_disk.value.final_disk_index].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = length(google_compute_disk.sap_hana_shared_disk) > 0 ? [1] : []
    content {
      device_name = google_compute_disk.sap_hana_shared_disk[0].name
      source      = google_compute_disk.sap_hana_shared_disk[0].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [] : [1]
    content {
      device_name = google_compute_disk.sap_hana_usrsap_disks[0].name
      source      = google_compute_disk.sap_hana_usrsap_disks[0].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = length(google_compute_disk.sap_hana_backup_disk) > 0 ? [1] : []
    content {
      device_name = google_compute_disk.sap_hana_backup_disk[0].name
      source      = google_compute_disk.sap_hana_backup_disk[0].self_link
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
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
    sap_hana_shared_nfs             = local.shared_nfs_endpoint
    sap_hana_backup_nfs             = local.backup_nfs_endpoint
    sap_hana_scaleout_nodes         = var.sap_hana_scaleout_nodes
    use_single_shared_data_log_disk = var.use_single_shared_data_log_disk
    sap_hana_backup_disk            = local.use_backup_disk
    sap_hana_shared_disk            = local.make_shared_disk
    sap_hana_data_disk_type         = local.final_data_disk_type
    enable_fast_restart             = var.enable_fast_restart
    native_bm                       = local.native_bm
    data_stripe_size                = var.data_stripe_size
    log_stripe_size                 = var.log_stripe_size
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

  dynamic "scheduling" {
    for_each = local.native_bm ? [1] : []
    content {
      on_host_maintenance = "TERMINATE"
    }
  }

  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [1] : []
    content {
      device_name = google_compute_disk.sap_hana_unified_worker_disks[count.index].name
      source      = google_compute_disk.sap_hana_unified_worker_disks[count.index].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [] : [for i in range(local.num_data_disks) : {
      final_disk_index = i + (count.index + 1) * local.num_data_disks
    }]
    content {
      device_name = google_compute_disk.sap_hana_data_disks[attached_disk.value.final_disk_index].name
      source      = google_compute_disk.sap_hana_data_disks[attached_disk.value.final_disk_index].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [] : [for i in range(local.num_log_disks) : {
      final_disk_index = i + (count.index + 1) * local.num_log_disks
    }]
    content {
      device_name = google_compute_disk.sap_hana_log_disks[attached_disk.value.final_disk_index].name
      source      = google_compute_disk.sap_hana_log_disks[attached_disk.value.final_disk_index].self_link
    }
  }
  dynamic "attached_disk" {
    for_each = var.use_single_shared_data_log_disk ? [] : [1]
    content {
      device_name = google_compute_disk.sap_hana_usrsap_disks[count.index + 1].name
      source      = google_compute_disk.sap_hana_usrsap_disks[count.index + 1].self_link
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
    startup-script                  = local.secondary_startup_url
    post_deployment_script          = var.post_deployment_script
    sap_deployment_debug            = var.sap_deployment_debug
    sap_hana_deployment_bucket      = var.sap_hana_deployment_bucket
    sap_hana_sid                    = var.sap_hana_sid
    sap_hana_instance_number        = var.sap_hana_instance_number
    sap_hana_sidadm_password        = var.sap_hana_sidadm_password
    sap_hana_sidadm_password_secret = var.sap_hana_sidadm_password_secret
    sap_hana_system_password        = var.sap_hana_system_password
    sap_hana_system_password_secret = var.sap_hana_system_password_secret
    sap_hana_sidadm_uid             = var.sap_hana_sidadm_uid
    sap_hana_sapsys_gid             = var.sap_hana_sapsys_gid
    sap_hana_shared_nfs             = local.shared_nfs_endpoint
    sap_hana_backup_nfs             = local.backup_nfs_endpoint
    sap_hana_scaleout_nodes         = var.sap_hana_scaleout_nodes
    use_single_shared_data_log_disk = var.use_single_shared_data_log_disk
    sap_hana_backup_disk            = false
    sap_hana_shared_disk            = false
    enable_fast_restart             = var.enable_fast_restart
    native_bm                       = local.native_bm
    data_stripe_size                = var.data_stripe_size
    log_stripe_size                 = var.log_stripe_size
    template-type                   = "TERRAFORM"
  }

  lifecycle {
    # Ignore changes in the instance metadata, since it is modified by the SAP startup script.
    ignore_changes = [metadata]
  }
}
