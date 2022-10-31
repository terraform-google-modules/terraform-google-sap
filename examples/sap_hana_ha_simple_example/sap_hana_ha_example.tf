#
# Version:    2.0.2022101419281665775728
# Build Hash: 5f4ef08feb4fed0e1eabc3bfc4b2d64d99001ae7
#
module "sap_hana_ha" {
  source = "gcs::https://www.googleapis.com/storage/v1/core-connect-dm-templates/202210141928/terraform/sap_hana_ha/sap_hana_ha_module.zip"
  #
  # By default, this source file uses the latest release of the terraform module
  # for SAP on Google Cloud.  To fix your deployments to a specific release
  # of the module, comment out the source property above and uncomment the source property below.
  #
  # source = "gcs::https://www.googleapis.com/storage/v1/core-connect-dm-templates/202210141928/terraform/sap_hana_ha/sap_hana_ha_module.zip"
  #
  # Fill in the information below
  #
  ##############################################################################
  ## MANDATORY SETTINGS
  ##############################################################################
  # General settings
  project_id                      = "PROJECT_ID"          # example: my-project-x
  machine_type                    = "MACHINE_TYPE"        # example: n1-highmem-32
  network                         = "NETWORK"             # example: default
  subnetwork                      = "SUBNETWORK"          # example: default
  linux_image                     = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project             = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud

  primary_instance_name           = "PRIMARY_NAME"        # example: hana-ha-primary
  primary_zone                    = "PRIMARY_ZONE"        # example: us-east1-b, must be in the same region as secondary_zone

  secondary_instance_name         = "SECONDARY_NAME"      # example: hana-ha-secondary
  secondary_zone                  = "SECONDARY_ZONE"      # example: us-east1-c, must be in the same region as primary_zone

  ##############################################################################
  ## OPTIONAL SETTINGS
  ##   - default values will be determined/calculated
  ##############################################################################
  # HANA settings
  # sap_hana_deployment_bucket      = "GCS_BUCKET"          # default is ""
  # sap_hana_sid                    = "SID"                 # default is "", otherwise must conform to [a-zA-Z][a-zA-Z0-9]{2}
  # sap_hana_instance_number        = INSTANCE_NUMBER       # default is 0, must be a 2 digit positive number
  # sap_hana_sidadm_password        = "SID_ADM_PASSWORD"    # default is "", otherwise must contain one lower case letter, one upper case letter, one number, and be at least 8 characters in length
  # sap_hana_sidadm_password_secret = "SID_ADM_SECRET"      # default is "", otherwise must be the name of a secret in Secret Manager. The secret has the same constraints as "sap_hana_sidadm_password"
  # sap_hana_system_password        = "SYSTEM_PASSWORD"     # default is "", otherwise must contain one lower case letter, one upper case letter, one number, and be at least 8 characters in length
  # sap_hana_system_password_secret = "SYSTEM_SECRET"       # default is "", otherwise must be the name of a secret in Secret Manager. The secret has the same constraints as "sap_hana_system_password"
  # sap_hana_backup_size            = BACKUP_DISK_SIZE      # default is 0, minimum is 0
  # sap_hana_sidadm_uid             = HANA_SIDADM_UID       # default is 900
  # sap_hana_sapsys_gid             = HANA_SAPSYS_GID       # default is 79

  # sap_vip                         = IP_ADDRESS            # default is ""
  # primary_instance_group_name     = GROUP_NAME            # default is ""
  # secondary_instance_group_name   = GROUP_NAME            # default is ""
  # loadbalancer_name               = LB_NAME               # default is ""

  # network_tags                    = [ "TAG_NAME" ]          # default is an empty list
  # public_ip                       = true_or_false         # default is true
  # service_account                 = ""                    # default is an empty string
  # primary_reservation_name        = ""                    # default is an empty string
  # secondary_reservation_name      = ""                    # default is an empty string
}
