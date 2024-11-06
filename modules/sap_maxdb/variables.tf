
variable "project_id" {
  type        = string
  description = "Project id where the instances will be created"
}

variable "zone" {
  description = "Zone to create the resources in"
  type        = string
}

variable "instance_name" {
  description = "Hostname of the GCE instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type to deploy"
  type        = string
}

variable "subnetwork" {
  description = "The sub network to deploy the instance in"
  type        = string
}

variable "linux_image" {
  description = "Linux image name to use. family/sles-12-sp2-sap or family/sles-12-sp2-sap will use the latest SLES 12 SP2 or SP3 image"
  type        = string
}

variable "linux_image_project" {
  description = "The project which the Linux image belongs to"
  type        = string
}

variable "maxdb_sid" {
  description = "The database instance/SID name"
  type        = string
  validation {
    condition     = length(var.maxdb_sid) == 3 && can(regex("^([A-Z][A-Z0-9][A-Z0-9])", var.maxdb_sid))
    error_message = "The maxdb_sid must have a length of 3 and match the regex: '([A-Z][A-Z0-9][A-Z0-9])'."
  }
}

variable "maxdb_root_size" {
  description = "Size of /sapdb - the root directory of the database instance"
  type        = number
  default     = 8
  validation {
    condition     = var.maxdb_root_size >= 8
    error_message = "The variable maxdb_root_size must be 8 or larger."
  }
}

variable "maxdb_data_size" {
  description = "Size of /sapdb/[DBSID]/sapdata - Which holds the database data files"
  type        = number
  default     = 30
  validation {
    condition     = var.maxdb_data_size >= 30
    error_message = "The variable maxdb_data_size must be 30 or larger."
  }
}

variable "maxdb_log_size" {
  description = "Size of /sapdb/[DBSID]/saplog - Which holds the database transaction logs"
  type        = number
  default     = 8
  validation {
    condition     = var.maxdb_log_size >= 8
    error_message = "The variable maxdb_log_size must be 8 or larger."
  }
}

variable "maxdb_data_ssd" {
  description = "SSD toggle for the data drive. If set to true, the data disk will be SSD"
  type        = bool
  default     = true
}

variable "maxdb_log_ssd" {
  description = "SSD toggle for the log drive. If set to true, the log disk will be SSD"
  type        = bool
  default     = true
}

variable "maxdb_backup_size" {
  description = "OPTIONAL - Size of the /maxdbbackup volume. If set to 0, no disk will be created"
  type        = number
  default     = 0
}

variable "usr_sap_size" {
  description = "OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the ase database instance. If set to 0, no disk will be created"
  type        = number
  default     = 0
}

variable "sap_mnt_size" {
  description = "OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the ase database instance. If set to 0, no disk will be created"
  type        = number
  default     = 0
}

variable "swap_size" {
  description = "OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the ase database instance. If set to 0, no disk will be created"
  type        = number
  default     = 0
}

variable "network_tags" {
  description = "OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes"
  type        = list(string)
  default     = []
}

variable "public_ip" {
  description = "OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail"
  type        = bool
  default     = true
}

variable "sap_deployment_debug" {
  description = "OPTIONAL - If this value is set to anything, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging"
  type        = bool
  default     = false
}

variable "post_deployment_script" {
  description = "OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment"
  type        = string
  default     = ""
}

variable "primary_startup_url" {
  description = "Startup script to be executed when the VM boots, should not be overridden"
  type        = string
  default     = "curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_maxdb/startup.sh | bash -x -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"
}

variable "service_account" {
  description = "OPTIONAL - Ability to define a custom service account instead of using the default project service account"
  type        = string
  default     = ""
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

#
# DO NOT MODIFY unless you know what you are doing
#
variable "can_ip_forward" {
  type        = bool
  description = "Whether sending and receiving of packets with non-matching source or destination IPs is allowed."
  default     = true
}

variable "custom_metadata" {
  type = map(string)
  description = "Optional - default is empty. Custom metadata to be added to the VM."
  default     = {}
}
