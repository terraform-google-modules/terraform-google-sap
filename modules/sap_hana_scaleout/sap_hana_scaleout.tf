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
module "hana_scaleout" {
  source = "https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_scaleout/sap_hana_scaleout_module.zip"
  #
  # By default, this source file uses the latest release of the terraform module
  # for SAP on Google Cloud.  To fix your deployments to a specific release
  # of the module, comment out the source property above and uncomment the source property below.
  #
  # source = "https://storage.googleapis.com/cloudsapdeploy/terraform/DATETIME_OF_BUILD/terraform/sap_hana_scaleout/sap_hana_scaleout_module.zip"
  #
  # Fill in the information below
  #
  ##############################################################################
  ## MANDATORY SETTINGS
  ##############################################################################
  # General settings
  project_id          = "PROJECT_ID"          # example: my-project-x
  zone                = "ZONE"                # example: us-east1-b
  machine_type        = "MACHINE_TYPE"        # example: n1-highmem-32
  subnetwork          = "SUBNETWORK"          # example: default
  linux_image         = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud

  instance_name       = "VM_NAME"         # example: hana-instance
  sap_hana_sid        = "SID"             # example: ABC, Must conform to [a-zA-Z][a-zA-Z0-9]{2}
  sap_hana_shared_nfs = "HANA_SHARED_NFS" # example: 10.10.10.10:/shared
  sap_hana_backup_nfs = "HANA_BACKUP_NFS" # example: 10.10.10.10:/backup

  ##############################################################################
  ## OPTIONAL SETTINGS
  ##   - default values will be determined/calculated
  ##############################################################################
  # HANA settings
  # sap_hana_deployment_bucket      = "GCS_BUCKET"          # default is ""
  # sap_hana_instance_number        = INSTANCE_NUMBER       # default is 0, must be a 2 digit positive number
  # sap_hana_sidadm_password        = "SID_ADM_PASSWORD"    # default is "", otherwise must contain one lower case letter, one upper case letter, one number, and be at least 8 characters in length
  # sap_hana_sidadm_password_secret = "SID_ADM_SECRET"      # default is "", otherwise must be the name of a secret in Secret Manager. The secret has the same constraints as "sap_hana_sidadm_password"
  # sap_hana_system_password        = "SYSTEM_PASSWORD"     # default is "", otherwise must contain one lower case letter, one upper case letter, one number, and be at least 8 characters in length
  # sap_hana_system_password_secret = "SYSTEM_SECRET"       # default is "", otherwise must be the name of a secret in Secret Manager that has the same constraints as "sap_hana_system_password"
  # sap_hana_sidadm_uid             = HANA_SIDADM_UID       # default is 900
  # sap_hana_sapsys_gid             = HANA_SAPSYS_GID       # default is 79

  # Scaleout settings
  # sap_hana_worker_nodes           = WORKER_NODES_NUM      # default is 1, must be at least 1, at most 15
  # sap_hana_standby_nodes          = STANDBY_NODES_NUM     # default is 1, must be at least 1, at most 3

  # network_tags                    = [ "TAG_NAME" ]        # default is an empty list
  # nic_type                        = "NIC_TYPE"            # default is machine type dependent. Must be "VIRTIO_NET" or "GVNIC"
  # public_ip                       = true_or_false         # default is true
  # service_account                 = ""                    # default is an empty string
  # reservation_name                = ""                    # default is an empty string
  # vm_static_ip                    = ""                    # default is an empty string, example: "10.0.0.1"
  # worker_static_ips               = [ "IP1", "IP2" ]      # default is an empty list, example: ["10.0.0.2", "10.0.0.3"]
  # standby_static_ips              = [ "IP1", "IP2" ]      # default is an empty list, example: ["10.0.0.4", "10.0.0.5"]

  # disk_type                       = "DISK_TYPE"           # default is pd-ssd, except for machines that do not support PD, in which case the default is hyperdisk-extreme. The default disk type to use for disk(s) containing log and data volumes. Valid types are "pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-balanced", "hyperdisk-extreme".
  # use_single_data_log_disk        = true_or_false         # default is false
}
