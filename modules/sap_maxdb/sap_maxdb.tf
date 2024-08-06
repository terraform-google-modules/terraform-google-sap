
#
# Version:    DATETIME_OF_BUILD
#
module "maxdb" {
  source = "https://storage.googleapis.com/cloudsapdeploy/terraform/DATETIME_OF_BUILD/dm-templates/sap_maxdb/sap_maxdb_module.zip"
  #
  # By default, this source file uses the latest release of the terraform module
  # for SAP on Google Cloud.  To fix your deployments to a specific release
  # of the module, comment out the source property above and uncomment the source property below.
  #
  # source = "https://storage.googleapis.com/cloudsapdeploy/terraform/DATETIME_OF_BUILD/dm-templates/sap_maxdb/sap_maxdb_module.zip"
  #
  # Fill in the information below
  #
  instance_name       = "VM_NAME"            # example: max-db-instance
  machine_type        = "MACHINE_TYPE"       # example: n1-highmem-32
  project_id          = "PROJECT_ID"         # example: customer-project-x
  zone                = "ZONE"               # example: us-central1-a
  subnetwork          = "SUBNETWORK"         # example: default
  linux_image         = "IMAGE_FAMILY"       # example: sles-15-sp2-sap
  linux_image_project = "IMAGE_PROJECT"      # example: suse-sap-cloud
  maxdb_sid           = "MAXDB_DATABASE_SID" # example: SID

  # Optional disk configuration

  # maxdb_root_size            = ROOT_DISK_SIZE # in GB, default is 8
  # maxdb_data_size            = DATA_DISK_SIZE # in GB, default is 30
  # maxdb_log_size             = LOG_DISK_SIZE  # in GB, default is 8
  # maxdb_data_ssd             = TRUE_OR_FALSE       # default is true
  # maxdb_log_ssd              = TRUE_OR_FALSE       # default is true

  # Optional advanced options

  # maxdb_backup_size         = BACKUP_DISK_SIZE  # in GB, default is 0 and will not be created
  # usr_sap_size              = USR_DISK_SIZE # Required if SAP NetWeaver is on same VM in GB, default is 0 and will not be created
  # sap_mnt_size               = MNT_DISK_SIZE # Required if SAP NetWeaver is on same VM in GB, default is 0 and will not be created
  # swap_size                 = SWAP_DISK_SIZE # Required if SAP NetWeaver is on same VM in GB, default is 0 and will not be created

  # Optional advanced options
  # network_tags           = [ "TAG_NAME" ]           # default is an empty list
  # public_ip              = TRUE_OR_FALSE            # default is true
  # service_account        = "CUSTOM_SERVICE_ACCOUNT"
  # sap_deployment_debug   = TRUE_OR_FALSE            # default is false
  # reservation_name       = "RESERVATION_NAME"
}
