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
variable "project_id" {
  type        = string
  description = "Project id where the instances will be created."
}

variable "zone" {
  type        = string
  description = "Zone where the instances will be created."
}

variable "machine_type" {
  type        = string
  description = "Machine type for the instances."
}

variable "subnetwork" {
  type        = string
  description = "The sub network to deploy the instance in."
}

variable "linux_image" {
  type        = string
  description = "Linux image name to use."
}

variable "linux_image_project" {
  type        = string
  description = "The project which the Linux image belongs to."
}

variable "instance_name" {
  type        = string
  description = "Hostname of the GCE instance."
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.instance_name))
    error_message = "The instance_name must consist of lowercase letters (a-z), numbers, and hyphens."
  }
}

variable "sap_hana_deployment_bucket" {
  type        = string
  description = "The Cloud Storage path that contains the SAP HANA media, do not include gs://. If this is not defined, the GCE instance will be provisioned without SAP HANA installed."
  validation {
    condition     = (!(length(regexall("gs:", var.sap_hana_deployment_bucket)) > 0))
    error_message = "The sap_hana_deployment_bucket must only contain the Cloud Storage path, which includes the bucket name and the names of any folders. Do not include gs://."
  }
  default = ""
}

variable "sap_hana_sid" {
  type        = string
  description = "The SAP HANA SID. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. SID must adhere to SAP standard (Three letters or numbers and start with a letter)"
  validation {
    condition     = length(var.sap_hana_sid) == 3 && can(regex("[A-Z][A-Z0-9]{2}", var.sap_hana_sid))
    error_message = "The sap_hana_sid must be 3 characters long and start with a letter and all letters must be capitalized."
  }
}

variable "sap_hana_instance_number" {
  type        = number
  description = "The SAP instance number. If this is not defined, the GCE instance will be provisioned without SAP HANA installed."
  default     = 0
  validation {
    condition     = (var.sap_hana_instance_number >= 0) && (var.sap_hana_instance_number < 100)
    error_message = "The sap_hana_instance_number must be a number between 0 and 99."
  }
}

variable "sap_hana_sidadm_password" {
  type        = string
  description = "The linux sidadm login password. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. Minimum requirement is 8 characters."
  default     = ""
  validation {
    condition = (length(var.sap_hana_sidadm_password) == 0 ||
      (length(var.sap_hana_sidadm_password) >= 8 &&
        can(regex("[0-9]", var.sap_hana_sidadm_password)) &&
        can(regex("[a-z]", var.sap_hana_sidadm_password)) &&
    can(regex("[A-Z]", var.sap_hana_sidadm_password))))
    error_message = "The sap_hana_sidadm_password must have at least 8 characters. Must contain at least one capitalized letter, one lowercase letter, and one number."
  }
}

variable "sap_hana_sidadm_password_secret" {
  type        = string
  description = "The secret key used to retrieve the linux sidadm login from Secret Manager (https://cloud.google.com/secret-manager). The Secret Manager password will overwrite the clear text password from sap_hana_sidadm_password if both are set."
  default     = ""
}

variable "sap_hana_system_password" {
  type        = string
  description = "The SAP HANA SYSTEM password. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. Minimum requirement is 8 characters with at least 1 number."
  default     = ""
  validation {
    condition = (length(var.sap_hana_system_password) == 0 ||
      (length(var.sap_hana_system_password) >= 8 &&
        can(regex("[0-9]", var.sap_hana_system_password)) &&
        can(regex("[a-z]", var.sap_hana_system_password)) &&
    can(regex("[A-Z]", var.sap_hana_system_password))))
    error_message = "The sap_hana_system_password must have at least 8 characters. Must contain at least one capitalized letter, one lowercase letter, and one number."
  }
}

variable "sap_hana_system_password_secret" {
  type        = string
  description = "The secret key used to retrieve the SAP HANA SYSTEM login from Secret Manager (https://cloud.google.com/secret-manager). The Secret Manager password will overwrite the clear text password from sap_hana_system_password if both are set."
  default     = ""
}

variable "sap_hana_scaleout_nodes" {
  type        = number
  description = "Number of additional nodes to add. E.g - if you wish for a 4 node cluster you would specify 3 here."
  default     = 0
  validation {
    condition     = var.sap_hana_scaleout_nodes >= 0
    error_message = "The sap_hana_scaleout_nodes must be positive or 0."
  }
}
variable "sap_hana_backup_nfs_resource" {
  default = null
  type = object({
    networks = list(
      object({
        ip_addresses = list(string)
      })
    )
    file_shares = list(
      object({
        name = string
      })
    )

  })
  description = "NFS resource to be used as the backup drive instead of a disk. This and sap_hana_backup_nfs may not both be set."
}
variable "sap_hana_shared_nfs_resource" {
  default = null
  type = object({
    networks = list(
      object({
        ip_addresses = list(string)
      })
    )
    file_shares = list(
      object({
        name = string
      })
    )

  })
  description = "NFS resource to be used as the shared drive instead of a disk. This and sap_hana_shared_nfs may not both be set."
}

variable "sap_hana_shared_nfs" {
  type    = string
  default = ""
  validation {
    condition     = var.sap_hana_shared_nfs == "" || can(regex("(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}:\\/[^[:space:]]*", var.sap_hana_shared_nfs))
    error_message = "The sap_hana_backup_nfs must be an IP address followed by ':/' then some name."
  }
  description = "NFS endpoint for /hana/shared storage."
}

variable "sap_hana_backup_nfs" {
  type    = string
  default = ""
  validation {
    condition     = var.sap_hana_backup_nfs == "" || can(regex("(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}:\\/[^[:space:]]*", var.sap_hana_backup_nfs))
    error_message = "The sap_hana_backup_nfs must be an IP address followed by ':/' then some name."
  }
  description = "NFS endpoint for /hanabackup storage."
}

variable "sap_hana_backup_size" {
  type        = number
  description = "Size in GB of the /hanabackup volume. If this is not set or set to zero, the GCE instance will be provisioned with a hana backup volume of 2 times the total memory. If sap_hana_backup_nfs is set, this setting is ignored."
  default     = 0
  validation {
    condition     = var.sap_hana_backup_size >= 0
    error_message = "The sap_hana_backup_size must be positive or 0."
  }
}

variable "sap_hana_sidadm_uid" {
  type        = number
  description = "The Linux UID of the <SID>adm user. By default this is set to 900 to avoid conflicting with other OS users."
  default     = 900
}

variable "sap_hana_sapsys_gid" {
  type        = number
  description = "The Linux GID of the SAPSYS group. By default this is set to 79"
  default     = 79
}

variable "network_tags" {
  type        = list(string)
  description = "OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes."
  default     = []
}

variable "public_ip" {
  type        = bool
  description = "OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail."
  default     = true
}

variable "service_account" {
  type        = string
  description = "OPTIONAL - Ability to define a custom service account instead of using the default project service account."
  default     = ""
}

variable "sap_deployment_debug" {
  type        = bool
  description = "OPTIONAL - If this value is set to true, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging."
  default     = false
}

variable "reservation_name" {
  type        = string
  description = <<-EOT
  Use a reservation specified by RESERVATION_NAME.
  By default ANY_RESERVATION is used when this variable is empty.
  In order for a reservation to be used it must be created with the
  "Select specific reservation" selected (specificReservationRequired set to true)
  Be sure to create your reservation with the correct Min CPU Platform for the
  following instance types:
  n1-highmem-32 : Intel Broadwell
  n1-highmem-64 : Intel Broadwell
  n1-highmem-96 : Intel Skylake
  n1-megamem-96 : Intel Skylake
  m1-megamem-96 : Intel Skylake
  All other instance types can have automatic Min CPU Platform"
  EOT
  default     = ""
}

variable "post_deployment_script" {
  type        = string
  description = "OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment."
  default     = ""
}

variable "nic_type" {
  type        = string
  description = "Optional - This value determines the type of NIC to use, valid options are GVNIC and VIRTIO_NET. If choosing GVNIC make sure that it is supported by your OS choice here https://cloud.google.com/compute/docs/images/os-details#networking."
  validation {
    condition     = contains(["VIRTIO_NET", "GVNIC", ""], var.nic_type)
    error_message = "The nic_type must be either GVNIC or VIRTIO_NET."
  }
  default = ""
}

variable "disk_type" {
  type        = string
  description = "Optional - The default disk type to use on all disks deployed. Extreme disks are not supported on all machine types. See https://cloud.google.com/compute/docs/disks/ for details."
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme"], var.disk_type)
    error_message = "The disk_type must be either pd-ssd, pd-balanced, pd-extreme, hyperdisk-balanced,  or hyperdisk-extreme."
  }
  default = "pd-ssd"
}

variable "use_single_shared_data_log_disk" {
  type        = bool
  description = "Optional - By default three separate disk for data, logs, and shared will be made. If set to true, one disk will be used instead."
  default     = false
}

variable "include_backup_disk" {
  type        = bool
  description = "Optional - The default is true. If set creates a disk for backups."
  default     = true
}

variable "backup_disk_type" {
  type        = string
  description = "Optional - The default is pd-balanced, only used if a backup disk is needed."
  default     = "pd-balanced"
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme"], var.backup_disk_type)
    error_message = "The disk_type must be either pd-ssd, pd-balanced, pd-standard, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
}

variable "vm_static_ip" {
  type        = string
  description = "Optional - Defines an internal static IP for the VM."
  validation {
    condition     = var.vm_static_ip == "" || can(regex("^(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$", var.vm_static_ip))
    error_message = "The vm_static_ip must be a valid IP address."
  }
  default = ""
}

variable "worker_static_ips" {
  type        = list(string)
  description = "Optional - Defines internal static IP addresses for the worker nodes."
  validation {
    condition = alltrue([
      for ip in var.worker_static_ips : ip == "" || can(regex("^(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$", ip))
    ])
    error_message = "All worker_static_ips must be valid IP addresses."
  }
  default = []
}

variable "enable_fast_restart" {
  type        = bool
  description = "Optional - The default is true. If set enables HANA Fast Restart."
  default     = true
}

variable "hyperdisk_balanced_iops_default" {
  type        = number
  description = "Optional - default is 3000. Number of IOPS that is set for each disk of type Hyperdisk-balanced (except for boot/usrsap/shared disks)."
  default     = 3000
}

variable "hyperdisk_balanced_throughput_default" {
  type        = number
  description = "Optional - default is 750. Throughput in MB/s that is set for each disk of type Hyperdisk-balanced (except for boot/usrsap/shared disks)."
  default     = 750
}

#
# DO NOT MODIFY unless instructed or aware of the implications of using those settings
#

variable "data_disk_type_override" {
  type        = string
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default_disk_type' for the data disk."
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme", ""], var.data_disk_type_override)
    error_message = "The data_disk_type_override must be either pd-ssd, pd-balanced, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
  default = ""
}
variable "log_disk_type_override" {
  type        = string
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default_disk_type' for the log disk."
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme", ""], var.log_disk_type_override)
    error_message = "The log_disk_type_override must be either pd-ssd, pd-balanced, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
  default = ""
}
variable "shared_disk_type_override" {
  type        = string
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default_disk_type' for the shared disk."
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme", ""], var.shared_disk_type_override)
    error_message = "The shared_disk_type_override must be either pd-ssd, pd-balanced, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
  default = ""
}
variable "usrsap_disk_type_override" {
  type        = string
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default_disk_type' for the /usr/sap disk."
  validation {
    condition     = contains(["pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme", ""], var.usrsap_disk_type_override)
    error_message = "The usrsap_disk_type_override must be either pd-ssd, pd-balanced, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
  default = ""
}

variable "unified_disk_size_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the primary's unified disk, that is based off of the machine_type."
  default     = null
}
variable "unified_worker_disk_size_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the unified worker disk(s), that is based off of the machine_type."
  default     = null
}
variable "data_disk_size_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the data disk(s), that is based off of the machine_type."
  default     = null
}
variable "log_disk_size_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the log disk(s), that is based off of the machine_type."
  default     = null
}
variable "shared_disk_size_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the shared disk, that is based off of the machine_type."
  default     = null
}
variable "usrsap_disk_size_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the /usr/sap disk(s), that is based off of the machine_type."
  default     = null
}

variable "unified_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the primary's unified disk will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "unified_worker_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the unified worker disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "data_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the data disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "log_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the log disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "shared_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the shared disk will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "usrsap_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the /usr/sap disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "backup_disk_iops_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the backup disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "unified_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the primary's unified disk will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "unified_worker_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the unified worker disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "data_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the data disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "log_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the log disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "shared_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the shared disk will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "usrsap_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the /usr/sap disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "backup_disk_throughput_override" {
  type        = number
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the backup disk(s) will use. Has no effect if not using a disk type that supports it."
  default     = null
}
variable "primary_startup_url" {
  type        = string
  description = "Startup script to be executed when the VM boots, should not be overridden."
  default     = "curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202402230649/terraform/sap_hana/startup.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202402230649/terraform"
}

variable "secondary_startup_url" {
  type        = string
  default     = "curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202402230649/terraform/sap_hana/startup_secondary.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202402230649/terraform"
  description = "DO NOT USE"
}

variable "can_ip_forward" {
  type        = bool
  description = "Whether sending and receiving of packets with non-matching source or destination IPs is allowed."
  default     = true
}
