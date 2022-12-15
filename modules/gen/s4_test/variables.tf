

variable "allow_stopping_for_update" {
  default = false
}

variable "app_disk_export_interfaces_size" {
  default = 128
}

variable "app_disk_usr_sap_size" {
  default = 256
}

variable "app_machine_type" {
  default = "e2-standard-32"
}

variable "ascs_disk_usr_sap_size" {
  default = 256
}

variable "ascs_machine_type" {
  default = "e2-standard-8"
}

variable "db_disk_export_backup_size" {
  default = 256
}

variable "db_disk_hana_data_size" {
  default = 256
}

variable "db_disk_hana_log_size" {
  default = 256
}

variable "db_disk_hana_restore_size" {
  default = 512
}

variable "db_disk_hana_shared_size" {
  default = 256
}

variable "db_disk_usr_sap_size" {
  default = 128
}

variable "db_machine_type" {
  default = "e2-standard-32"
}

variable "media_bucket_name" {
  default = "core-connect-dev-sap-installation-media"
}

variable "region_name" {
  default = "us-central1"
}

variable "sap_boot_disk_image" {
  default = "projects/suse-sap-cloud/global/images/sles-15-sp1-sap-v20221108-x86-64"
}

variable "vm_prefix" {
  default = "sapd"
}

variable "vpc_name" {
  default = "s4test-sap-s4-test"
}

variable "zone1_name" {
  default = "us-central1-a"
}

variable "zone2_name" {
  default = "us-central1-b"
}
