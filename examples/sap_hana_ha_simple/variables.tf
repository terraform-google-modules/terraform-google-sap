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

variable "sap_hana_deployment_bucket" {
  type        = string
  description = "The GCS bucket containing the SAP HANA media. If this is not defined, the GCE instance will be provisioned without SAP HANA installed."
  default     = ""
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
