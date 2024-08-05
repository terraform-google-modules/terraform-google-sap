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
# Version:    DATETIME_OF_BUILD
#
module "sap_hana_ha" {
  source = "https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_ha/sap_hana_ha_module.zip"
  #
  # By default, this source file uses the latest release of the terraform module
  # for SAP on Google Cloud.  To fix your deployments to a specific release
  # of the module, comment out the source property above and uncomment the source property below.
  #
  # source = "https://storage.googleapis.com/cloudsapdeploy/terraform/DATETIME_OF_BUILD/terraform/sap_hana_ha/sap_hana_ha_module.zip"
  #
  # Fill in the information below
  #
  ##############################################################################
  ## MANDATORY SETTINGS
  ##############################################################################
  # General settings
  project_id          = "PROJECT_ID"          # example: my-project-x
  machine_type        = "MACHINE_TYPE"        # example: n1-highmem-32
  network             = "NETWORK"             # example: default
  subnetwork          = "SUBNETWORK"          # example: default
  linux_image         = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud

  primary_instance_name = "PRIMARY_NAME" # example: hana-ha-primary
  primary_zone          = "PRIMARY_ZONE" # example: us-east1-b, must be in the same region as secondary_zone

  secondary_instance_name = "SECONDARY_NAME" # example: hana-ha-secondary
  secondary_zone          = "SECONDARY_ZONE" # example: us-east1-c, must be in the same region as primary_zone

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

  # HANA Scaleout settings
  # sap_hana_scaleout_nodes         = NUM_SCALEOUT_NODES    # default is 0

  # Majority maker values must be specified if scaleout_nodes is >0
  # majority_maker_instance_name    = "MM_INSTANCE_NAME"    # default is empty, must be specified if scaleout_nodes>0
  # majority_maker_machine_type     = "MM_MACHINE_TYPE"     # default is empty, must be specified if scaleout_nodes>0
  # majority_maker_zone             = "MM_ZONE"             # default is empty, must be specified if scaleout_nodes>0, should be different from primary_zone and secondary_zone, but in the same region

  # HA Settings
  # sap_vip                         = IP_ADDRESS            # default is ""
  # primary_instance_group_name     = GROUP_NAME            # default is ""
  # secondary_instance_group_name   = GROUP_NAME            # default is ""
  # loadbalancer_name               = LB_NAME               # default is ""

  # network_tags                    = [ "TAG_NAME" ]        # default is an empty list
  # nic_type                        = "NIC_TYPE"            # default is machine type dependent. Must be "VIRTIO_NET" or "GVNIC"
  # public_ip                       = true_or_false         # default is true
  # service_account                 = ""                    # default is an empty string
  # primary_reservation_name        = ""                    # default is an empty string
  # secondary_reservation_name      = ""                    # default is an empty string
  # primary_static_ip               = ""                    # default is an empty string, example: "10.0.0.1"
  # secondary_static_ip             = ""                    # default is an empty string, example: "10.0.0.2"
  # primary_worker_static_ips       = [ "IP1", "IP2" ]      # default is an empty list, example: ["10.0.0.3", "10.0.0.4"]
  # secondary_worker_static_ips     = [ "IP1", "IP2" ]      # default is an empty list, example: ["10.0.0.5", "10.0.0.6"]


  # disk_type                       = "DISK_TYPE"           # default is pd-ssd, except for machines that do not support PD, in which case the default is hyperdisk-extreme. The default disk type to use for disk(s) containing log and data volumes. Valid types are "pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme".
  # use_single_shared_data_log_disk = true_or_false         # default is false
  # include_backup_disk             = true_or_false         # default is true
  # backup_disk_type                = "DISK_TYPE"           # default is pd-ssd, except for machines that do not support PD, in which case the default is hyperdisk-extreme. Valid types are "pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme".
  # enable_fast_restart             = true_or_false         # default is true, whether to enable HANA Fast Restart
  # enable_data_striping            = true_or_false         # default is false. Enable LVM striping of data volume across multiple disks. Data striping is only intended for cases where the machine level limits are higher than the hyperdisk disk level limits. Refer to https://cloud.google.com/compute/docs/disks/hyperdisks#hd-performance-limits
}
