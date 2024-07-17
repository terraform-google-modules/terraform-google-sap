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
# Version:    BUILD.VERSION
# Build Hash: BUILD.HASH
#
module "sap_nw" {
  source = "TERRAFORM_PREFIXTERRAFORM_URL_LATEST/terraform/sap_nw/sap_nw_module.zip"
  #
  # By default, this source file uses the latest release of the terraform module
  # for SAP on a Google Cloud.  To fix your deployments to a specific release
  # of the module, comment out the source property above and uncomment the source property below.
  #
  # source = "TERRAFORM_PREFIXTERRAFORM_URL/terraform/sap_nw/sap_nw_module.zip"
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

  instance_name = "VM_NAME" # example: nw-instance

  ##############################################################################
  ## OPTIONAL SETTINGS
  ##   - default values will be determined/calculated
  ##############################################################################
  # usr_sap_size         = USR_SAP_DISK_SIZE     # default is 0, minimum is 0
  # sap_mnt_size         = SAP_MNT_DISK_SIZE     # default is 0, minimum is 0
  # swap_size            = SWAP_SIZE             # default is 0, minimum is 0
  # network_tags         = [ "TAG_NAME" ]        # default is an empty list
  # public_ip            = true_or_false         # default is true
  # service_account      = ""                    # default is an empty string
  # reservation_name     = ""                    # default is an empty string
  # can_ip_forward       = true_or_false         # default is true
}
