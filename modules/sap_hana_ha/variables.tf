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

variable "primary_zone" {
  type        = string
  description = "Zone where the primary instances will be created."
}

variable "secondary_zone" {
  type        = string
  description = "Zone where the secondary instances will be created."
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

variable "primary_instance_name" {
  type        = string
  description = "Hostname of the primary GCE instance."
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.primary_instance_name))
    error_message = "The primary_instance_name must consist of lowercase letters (a-z), numbers, and hyphens."
  }
}

variable "secondary_instance_name" {
  type        = string
  description = "Hostname of the secondary GCE instance."
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.secondary_instance_name))
    error_message = "The secondary_instance_name must consist of lowercase letters (a-z), numbers, and hyphens."
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
  default     = ""
  validation {
    condition = length(var.sap_hana_sid) == 0 || (
    length(var.sap_hana_sid) == 3 && can(regex("[A-Z][A-Z0-9]{2}", var.sap_hana_sid)))
    error_message = "The sap_hana_sid must be 3 characters long and start with a letter and all letters must be capitalized."
  }
}

variable "sap_hana_instance_number" {
  type        = number
  description = "The SAP instance number. If this is not defined, the GCE instance will be provisioned without SAP HANA installed."
  default     = 0
  validation {
    condition     = (var.sap_hana_instance_number >= 0) && (var.sap_hana_instance_number < 100)
    error_message = "The sap_hana_instance_number must be 2 digits long."
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
    error_message = "The sap_hanasidadm_password must have at least 8 characters. Must contain at least one capitalized letter, one lowercase letter, and one number."
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

variable "sap_hana_backup_size" {
  type        = number
  description = "Size in GB of the /hanabackup volume. If this is not set or set to zero, the GCE instance will be provisioned with a hana backup volume of 2 times the total memory."
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

variable "sap_vip" {
  type        = string
  description = "OPTIONAL - The virtual IP address of the alias/route pointing towards the active SAP HANA instance. For a route based solution this IP must sit outside of any defined networks."
  default     = ""
}

variable "primary_instance_group_name" {
  type        = string
  description = "OPTIONAL - Unmanaged instance group to be created for the primary node. If blank, will use ig-VM_NAME"
  default     = ""
}

variable "secondary_instance_group_name" {
  type        = string
  description = "OPTIONAL - Unmanaged instance group to be created for the secondary node. If blank, will use ig-VM_NAME"
  default     = ""
}

variable "network" {
  type        = string
  description = "Network in which the ILB resides including resources like firewall rules."
}

variable "loadbalancer_name" {
  type        = string
  description = "OPTIONAL - Name of the load balancer that will be created. If left blank with use_ilb_vip set to true, then will use lb-SID as default"
  default     = ""
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

variable "primary_reservation_name" {
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

variable "secondary_reservation_name" {
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
  description = "Optional - The default disk type to use for disk(s) containing log and data volumes. The default is pd-ssd, except for machines that do not support PD, in which case the default is hyperdisk-extreme. Not all disk are supported on all machine types - see https://cloud.google.com/compute/docs/disks/ for details."
  validation {
    condition     = contains(["", "pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme"], var.disk_type)
    error_message = "The disk_type must be either pd-ssd, pd-balanced, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
  default = ""
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

variable "sap_hana_scaleout_nodes" {
  type        = number
  description = "Optional - Specify to add scaleout nodes to both HA instances."
  default     = 0
}

variable "majority_maker_instance_name" {
  type        = string
  description = "Optional - Name to use for the Majority Maker instance. Must be provided if scaleout_nodes > 0."
  default     = ""
}

variable "majority_maker_machine_type" {
  type        = string
  description = "Optional - The machine type to use for the Majority Maker instance. Must be provided if scaleout_nodes > 0."
  default     = ""
}

variable "majority_maker_zone" {
  type        = string
  description = "Optional - The zone in which the Majority Maker instance will be deployed. Must be provided if scaleout_nodes > 0. It is recommended for this to be different from the zones the primary and secondary instance are deployed in."
  default     = ""
}

variable "primary_static_ip" {
  type        = string
  description = "Optional - Defines an internal static IP for the primary VM."
  validation {
    condition     = var.primary_static_ip == "" || can(regex("^(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$", var.primary_static_ip))
    error_message = "The primary_static_ip must be a valid IP address."
  }
  default = ""
}

variable "secondary_static_ip" {
  type        = string
  description = "Optional - Defines an internal static IP for the secondary VM."
  validation {
    condition     = var.secondary_static_ip == "" || can(regex("^(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$", var.secondary_static_ip))
    error_message = "The secondary_static_ip must be a valid IP address."
  }
  default = ""
}

variable "primary_worker_static_ips" {
  type        = list(string)
  description = "Optional - Defines internal static IP addresses for the primary worker nodes."
  validation {
    condition = alltrue([
      for ip in var.primary_worker_static_ips : ip == "" || can(regex("^(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$", ip))
    ])
    error_message = "All primary_worker_static_ips must be valid IP addresses."
  }
  default = []
}

variable "secondary_worker_static_ips" {
  type        = list(string)
  description = "Optional - Defines internal static IP addresses for the secondary worker nodes."
  validation {
    condition = alltrue([
      for ip in var.secondary_worker_static_ips : ip == "" || can(regex("^(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$", ip))
    ])
    error_message = "All secondary_worker_static_ips must be valid IP addresses."
  }
  default = []
}

variable "backup_disk_type" {
  type        = string
  description = "Optional - The default is pd-ssd, except for machines that do not support PD, in which case the default is hyperdisk-extreme. Only used if a backup disk is needed."
  validation {
    condition     = contains(["", "pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme"], var.backup_disk_type)
    error_message = "The disk_type must be either pd-ssd, pd-balanced, pd-standard, pd-extreme, hyperdisk-balanced, or hyperdisk-extreme."
  }
  default = ""
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

variable "enable_fast_restart" {
  type        = bool
  description = "Optional - The default is true. If set enables HANA Fast Restart."
  default     = true
}

variable "enable_data_striping" {
  type        = bool
  description = "Optional - default is false. Enable LVM striping of data volume across multiple disks."
  default     = false
}

variable "sole_tenant_deployment" {
  type        = bool
  description = "Optional - default is false. Deploy on Sole Tenant Nodes."
  default     = false
}

variable "sole_tenant_node_type" {
  type        = string
  description = "Optional - default is null. Sole Tenant Node Type to use. See https://cloud.google.com/compute/docs/nodes/sole-tenant-nodes#node_types"
  default     = null
}

variable "sole_tenant_name_prefix" {
  type        = string
  description = "Optional - name of the prefix to use for the Sole Tenant objects (Node Templates, Node Groups). If left blank with sole_tenant_deployment=true, st-<sap_hana_sid> will be used."
  default     = ""
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
  description = "Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the primary disk(s), that is based off of the machine_type."
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

variable "wlm_deployment_name" {
  type        = string
  description = "Deployment name to be used for integrating into Work Load Management."
  default     = ""
}

variable "is_work_load_management_deployment" {
  type        = bool
  description = "If set the necessary tags and labels will be added to resoucres to support WLM."
  default     = false
}

variable "primary_startup_url" {
  type        = string
  description = "Startup script to be executed when the VM boots, should not be overridden."
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_ha/hana_ha_startup.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
}

variable "worker_startup_url" {
  type        = string
  description = "Startup script to be executed when the worker VM boots, should not be overridden."
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_ha/hana_ha_startup_worker.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
}

variable "secondary_startup_url" {
  type        = string
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_ha/hana_ha_startup_secondary.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
  description = "DO NOT USE"
}

variable "majority_maker_startup_url" {
  type        = string
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_ha/hana_ha_startup_majority_maker.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
  description = "DO NOT USE"
}

variable "can_ip_forward" {
  type        = bool
  description = "Whether sending and receiving of packets with non-matching source or destination IPs is allowed."
  default     = true
}

variable "enable_log_striping" {
  type        = bool
  description = "Optional - default is false. Enable LVM striping of log volume across multiple disks."
  default     = false
}

variable "number_data_disks" {
  type        = number
  description = "Optional - default is 2. Number of disks to use for data volume striping (if enable_data_striping = true)."
  default     = 2
}

variable "number_log_disks" {
  type        = number
  description = "Optional - default is 2. Number of disks to use for log volume striping (if enable_log_striping = true)."
  default     = 2
}

variable "data_stripe_size" {
  type        = string
  description = "Optional - default is 256k. Stripe size for data volume striping (if enable_data_striping = true)."
  default     = "256k"
}

variable "log_stripe_size" {
  type        = string
  description = "Optional - default is 64k. Stripe size for log volume striping (if enable_log_striping = true)."
  default     = "64k"
}
