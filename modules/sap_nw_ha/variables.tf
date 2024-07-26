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
##############################################################################
## MANDATORY SETTINGS
##############################################################################
#
# General settings
#
variable "project_id" {
  type        = string
  description = "Project id where the instances will be created"
}
variable "machine_type" {
  type        = string
  description = "Machine type for the instances"
}
variable "network" {
  type        = string
  description = "Network for the instances"
}
variable "subnetwork" {
  type        = string
  description = "Subnetwork for the instances"
}
variable "linux_image" {
  type        = string
  description = "Linux image name"
}
variable "linux_image_project" {
  type        = string
  description = "Linux image project"
}
#
# SCS settings
#
variable "sap_primary_instance" {
  type        = string
  description = "Name of first instance (initial SCS location)"
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.sap_primary_instance)) && length(var.sap_primary_instance) <= 13
    error_message = "The sap_primary_instance must consist of lowercase letters (a-z), numbers, and hyphens and be less than 14 characters long."
  }
}
variable "sap_primary_zone" {
  type        = string
  description = "Zone where the first instance will be created"
}
#
# ERS settings
#
variable "sap_secondary_instance" {
  type        = string
  description = "Name of second instance (initial ERS location)"
  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.sap_secondary_instance)) && length(var.sap_secondary_instance) <= 13
    error_message = "The sap_secondary_instance must consist of lowercase letters (a-z), numbers, and hyphens and be less than 14 characters long."
  }
}
variable "sap_secondary_zone" {
  type        = string
  description = "Zone where the second instance will be created"
}
#
# File system settings
#
variable "nfs_path" {
  type        = string
  description = "NFS path for shared file system, e.g. 10.163.58.114:/ssd"
  validation {
    condition     = var.nfs_path == "" || can(regex("(\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}:\\/[^[:space:]]*", var.nfs_path))
    error_message = "The nfs_path must be an IP address followed by ':/' then some name."
  }
}
#
# SAP system settings
#
variable "sap_sid" {
  type        = string
  description = "SAP System ID"
  validation {
    condition     = length(var.sap_sid) == 3 && can(regex("[A-Z][A-Z0-9]{2}", var.sap_sid))
    error_message = "The sap_sid must be 3 characters long and start with a letter and all letters must be capitalized."
  }
}

##############################################################################
## OPTIONAL SETTINGS (default values will be determined/calculated)
##############################################################################
#
# General settings
#
variable "hc_network_tag" {
  type        = list(string)
  default     = []
  description = "Network tag for the health check firewall rule"
}
variable "hc_firewall_rule_name" {
  type        = string
  default     = ""
  description = "Name of firewall rule for the health check"
}
#
# SCS settings
#
variable "scs_inst_group_name" {
  type        = string
  default     = ""
  description = "Name of SCS instance group"
}
variable "scs_hc_name" {
  type        = string
  default     = ""
  description = "Name of SCS health check"
}
variable "scs_hc_port" {
  type        = string
  default     = ""
  description = "Port of SCS health check"
}
variable "scs_vip_name" {
  type        = string
  default     = ""
  description = "Name of SCS virtual IP"
}
variable "scs_vip_address" {
  type        = string
  default     = ""
  description = "Address of SCS virtual IP"
}
variable "scs_backend_svc_name" {
  type        = string
  default     = ""
  description = "Name of SCS backend service"
}
variable "scs_forw_rule_name" {
  type        = string
  default     = ""
  description = "Name of SCS forwarding rule"
}
#
# ERS settings
#
variable "ers_inst_group_name" {
  type        = string
  default     = ""
  description = "Name of ERS instance group"
}
variable "ers_hc_name" {
  type        = string
  default     = ""
  description = "Name of ERS health check"
}
variable "ers_hc_port" {
  type        = string
  default     = ""
  description = "Port of ERS health check"
}
variable "ers_vip_name" {
  type        = string
  default     = ""
  description = "Name of ERS virtual IP"
}
variable "ers_vip_address" {
  type        = string
  default     = ""
  description = "Address of ERS virtual IP"
}
variable "ers_backend_svc_name" {
  type        = string
  default     = ""
  description = "Name of ERS backend service"
}
variable "ers_forw_rule_name" {
  type        = string
  default     = ""
  description = "Name of ERS forwarding rule"
}
#
# File system settings
#
variable "usr_sap_size" {
  type        = number
  default     = 8
  description = "Size of /usr/sap in GB"
  validation {
    condition     = var.usr_sap_size >= 8
    error_message = "Size of /usr/sap must be larger than 8 GB."
  }
}
variable "sap_mnt_size" {
  type        = number
  default     = 8
  description = "Size of /sapmnt in GB"

  validation {
    condition     = var.sap_mnt_size >= 8
    error_message = "Size of /sapmnt must be larger than 8 GB."
  }
}
variable "swap_size" {
  type        = number
  default     = 8
  description = "Size in GB of swap volume"

  validation {
    condition     = var.swap_size >= 8
    error_message = "Size of swap must be larger than 8 GB."
  }
}
#
# SAP system settings
#
variable "sap_scs_instance_number" {
  type        = string
  default     = "00"
  description = "SCS instance number"
  validation {
    condition     = length(var.sap_scs_instance_number) == 2 && tonumber(var.sap_scs_instance_number) >= 0
    error_message = "The length of sap_scs_instance_number must be 2. If you'd like a single digit (x) then enter it as (0x)."
  }
}
variable "sap_ers_instance_number" {
  type        = string
  default     = "10"
  description = "ERS instance number"
  validation {
    condition     = length(var.sap_ers_instance_number) == 2 && tonumber(var.sap_ers_instance_number) >= 0
    error_message = "The length of sap_ers_instance_number must be 2. If you'd like a single digit (x) then enter it as (0x)."
  }
}
variable "sap_nw_abap" {
  type        = bool
  default     = true
  description = "Is this a Netweaver ABAP installation. Set 'false' for NW Java. Dual stack is not supported by this script."
}
#
# Pacemaker settings
#
variable "pacemaker_cluster_name" {
  type        = string
  default     = ""
  description = "Name of Pacemaker cluster."
}
#
# Optional Settings
#
variable "public_ip" {
  type        = bool
  default     = false
  description = "Create an ephemeral public ip for the instances"
}
variable "service_account" {
  type        = string
  default     = ""
  description = <<-EOT
  Service account that will be used as the service account on the created instance.
  Leave this blank to use the project default service account
  EOT
}
variable "network_tags" {
  type        = list(string)
  default     = []
  description = "Network tags to apply to the instances"
}
variable "sap_deployment_debug" {
  type        = bool
  default     = false
  description = "Debug log level for deployment"
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
  m1-megamem-96 : "Intel Skylake"
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
  m1-megamem-96 : "Intel Skylake"
  All other instance types can have automatic Min CPU Platform"
  EOT
  default     = ""
}
#
# DO NOT MODIFY unless you know what you are doing
#
variable "primary_startup_url" {
  type        = string
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_nw_ha/nw_ha_startup_scs.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
  description = "DO NOT USE"
}
variable "secondary_startup_url" {
  type        = string
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_nw_ha/nw_ha_startup_ers.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
  description = "DO NOT USE"
}
variable "post_deployment_script" {
  type        = string
  default     = ""
  description = <<-EOT
  Specifies the location of a script to run after the deployment is complete.
  The script should be hosted on a web server or in a GCS bucket. The URL should
  begin with http:// https:// or gs://. Note that this script will be executed
  on all VM's that the template creates. If you only want to run it on the master
  instance you will need to add a check at the top of your script.
  EOT
}

#
# DO NOT MODIFY unless you know what you are doing
#
variable "can_ip_forward" {
  type        = bool
  description = "Whether sending and receiving of packets with non-matching source or destination IPs is allowed."
  default     = true
}
