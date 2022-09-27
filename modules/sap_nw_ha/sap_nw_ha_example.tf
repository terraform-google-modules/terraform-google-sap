#
# Version:    2.0.2022092713131664309621
# Build Hash: 32c641555bd6b4e0fc61df16a22f48913d50bacf
#
module "sap_nw_ha" {
  source = "gcs::https://www.googleapis.com/storage/v1/core-connect-dm-templates/202209271313/terraform/sap_nw_ha/sap_nw_ha_module.zip"
  #
  # By default, this source file uses the latest release of the terraform module
  # for SAP on Google Cloud.  To fix your deployments to a specific release
  # of the module, comment out the source property above and uncomment the source property below.
  #
  # source = "gcs::https://www.googleapis.com/storage/v1/core-connect-dm-templates/202209271313/terraform/sap_nw_ha/sap_nw_ha_module.zip"
  #
  # Fill in the information below
  #
  ##############################################################################
  ## MANDATORY SETTINGS
  ##############################################################################
  # General settings
  project_id                 = "PROJECT_ID"           # example: my-project-x
  machine_type               = "MACHINE_TYPE"         # example: n1-highmem-32
  network                    = "NETWORK"              # example: default
  subnetwork                 = "SUBNETWORK"           # example: default-subnet1
  linux_image                = "LINUX_IMAGE"          # example: sles-15-sp2-sap
  linux_image_project        = "LINUX_IMAGE_PROJECT"  # example: suse-sap-cloud

  sap_primary_instance       = "PRIMARY_INSTANCE"     # example: prd-nw1
  sap_primary_zone           = "PRIMARY_ZONE"         # example: us-central1-b

  sap_secondary_instance     = "SECONDARY_INSTANCE"   # example: prd-nw2
  sap_secondary_zone         = "SECONDARY_ZONE"       # example: us-central1-c

  nfs_path                   = "NFS_PATH"             # example: 1.2.3.4:/my_path

  sap_sid                    = "SID"                  # example: PE1

  ##############################################################################
  ## OPTIONAL SETTINGS
  ##   - default values will be determined/calculated
  ##############################################################################
  # hc_firewall_rule_name      = "[SID]-hc-allow"
  # hc_network_tag             = ["[SID]-hc-allow-tag"]

  # scs_inst_group_name        = "[SID]-scs-ig"
  # scs_hc_name                = "[SID]-scs-hc"
  # scs_hc_port                = "60000"
  # scs_vip_address            = "<next available IP>"
  # scs_vip_name               = "[SID]-scs-vip"
  # scs_backend_svc_name       = "[SID]-scs-backend-svc"
  # scs_forw_rule_name         = "[SID]-scs-fwd-rule"

  # ers_inst_group_name        = "[SID]-ers-ig"
  # ers_hc_name                = "[SID]-ers-hc"
  # ers_hc_port                = "60010"
  # ers_vip_address            = "<next available IP>"
  # ers_vip_name               = "[SID]-ers-vip"
  # ers_backend_svc_name       = "[SID]-ers-backend-svc"
  # ers_forw_rule_name         = "[SID]-ers-fwd-rule"

  # usr_sap_size               = USR_SAP_DISK_SIZE
  # sap_mnt_size               = SAP_MNT_DISK_SIZE
  # swap_size                  = SWAP_SIZE

  # sap_scs_instance_number    = "00"
  # sap_ers_instance_number    = "10"
  # sap_nw_abap                = true_or_false

  # pacemaker_cluster_name     = "[SID]-cluster"

  # public_ip                  = true_or_false
  # service_account            = ""
  # network_tags               = [ "TAG_NAME" ]
  # primary_reservation_name   = ""
  # secondary_reservation_name = ""
}
