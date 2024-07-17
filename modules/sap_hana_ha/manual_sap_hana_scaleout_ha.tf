module "sap_hana_primary" {
  source = "https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana/sap_hana_module.zip"

  ##############################################################################
  ## MANDATORY SETTINGS
  ##############################################################################
  # General settings
  project_id          = "PROJECT_ID"          # example: my-project-x
  zone                = "ZONE-A"              # example: us-east1-a
  machine_type        = "MACHINE_TYPE"        # example: n1-highmem-32
  subnetwork          = "SUBNETWORK"          # example: default
  linux_image         = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud

  instance_name = "VM_NAME" # example: hana_instance
  sap_hana_sid  = "SID"     # example: ABC, Must conform to [a-zA-Z][a-zA-Z0-9]{2}

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
  # sap_hana_system_password_secret = "SYSTEM_SECRET"       # default is "", otherwise must be the name of a secret in Secret Manager. The secret has the same constraints as "sap_hana_system_password"
  # sap_hana_scaleout_nodes         = SCALEOUT_NODES_NUM    # default is 0, minimum is 0
  # sap_hana_backup_size            = BACKUP_DISK_SIZE      # default is 0, minimum is 0
  # sap_hana_sidadm_uid             = HANA_SIDADM_UID       # default is 900
  # sap_hana_sapsys_gid             = HANA_SAPSYS_GID       # default is 79

  # sap_hana_shared_nfs             = "HANA_SHARED_NFS"     # default is "", example: "10.10.10.10:/shared"
  # sap_hana_backup_nfs             = "HANA_BACKUP_NFS"     # default is "", example: "10.10.10.10:/backup"

  # sap_hana_shared_nfs_resource    = resource.google_filestore_instance.shared_nfs     # default is null.
  # sap_hana_backup_nfs_resource    = resource.google_filestore_instance.backup_nfs     # default is null.

  # network_tags                    = [ "TAG_NAME" ]        # default is an empty list
  # nic_type                        = "NIC_TYPE"            # default is machine type dependent. Must be "VIRTIO_NET" or "GVNIC"
  # public_ip                       = true_or_false         # default is true
  # service_account                 = ""                    # default is an empty string
  # reservation_name                = ""                    # default is an empty string
  # vm_static_ip                    = ""                    # default is an empty string, example: "10.0.0.1"
  # worker_static_ips               = [ "IP1", "IP2" ]      # default is an empty list, example: ["10.0.0.2", "10.0.0.3"]

  # disk_type                       = "DISK_TYPE"           # default is "pd-ssd", sets what type of disk to use on all VMs. Valid types are "pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-extreme".
  # use_single_shared_data_log_disk = true_or_false         # default is false
  # include_backup_disk             = true_or_false         # default is true
  # backup_disk_type                = "DISK_TYPE"           # default is "pd-balanced", sets what type of disk to use on all VMs. Valid types are "pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-extreme".
}

module "sap_hana_secondary" {
  source = "https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana/sap_hana_module.zip"

  ##############################################################################
  ## MANDATORY SETTINGS
  ##############################################################################
  # General settings
  project_id          = "PROJECT_ID"          # example: my-project-x
  zone                = "ZONE-B"              # example: us-east1-b
  machine_type        = "MACHINE_TYPE"        # example: n1-highmem-32
  subnetwork          = "SUBNETWORK"          # example: default
  linux_image         = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud

  instance_name = "VM_NAME" # example: hana_instance
  sap_hana_sid  = "SID"     # example: ABC, Must conform to [a-zA-Z][a-zA-Z0-9]{2}

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
  # sap_hana_system_password_secret = "SYSTEM_SECRET"       # default is "", otherwise must be the name of a secret in Secret Manager. The secret has the same constraints as "sap_hana_system_password"
  # sap_hana_scaleout_nodes         = SCALEOUT_NODES_NUM    # default is 0, minimum is 0
  # sap_hana_backup_size            = BACKUP_DISK_SIZE      # default is 0, minimum is 0
  # sap_hana_sidadm_uid             = HANA_SIDADM_UID       # default is 900
  # sap_hana_sapsys_gid             = HANA_SAPSYS_GID       # default is 79

  # sap_hana_shared_nfs             = "HANA_SHARED_NFS"     # default is "", example: "10.10.10.10:/shared"
  # sap_hana_backup_nfs             = "HANA_BACKUP_NFS"     # default is "", example: "10.10.10.10:/backup"

  # sap_hana_shared_nfs_resource    = resource.google_filestore_instance.shared_nfs     # default is null.
  # sap_hana_backup_nfs_resource    = resource.google_filestore_instance.backup_nfs     # default is null.

  # network_tags                    = [ "TAG_NAME" ]        # default is an empty list
  # nic_type                        = "NIC_TYPE"            # default is machine type dependent. Must be "VIRTIO_NET" or "GVNIC"
  # public_ip                       = true_or_false         # default is true
  # service_account                 = ""                    # default is an empty string
  # reservation_name                = ""                    # default is an empty string
  # vm_static_ip                    = ""                    # default is an empty string, example: "10.0.0.1"
  # worker_static_ips               = [ "IP1", "IP2" ]      # default is an empty list, example: ["10.0.0.2", "10.0.0.3"]

  # disk_type                       = "DISK_TYPE"           # default is "pd-ssd", sets what type of disk to use on all VMs. Valid types are "pd-ssd", "pd-balanced", "pd-extreme", "hyperdisk-extreme".
  # use_single_shared_data_log_disk = true_or_false         # default is false
  # include_backup_disk             = true_or_false         # default is true
  # backup_disk_type                = "DISK_TYPE"           # default is "pd-balanced", sets what type of disk to use on all VMs. Valid types are "pd-ssd", "pd-balanced", "pd-standard", "pd-extreme", "hyperdisk-extreme".
}

resource "google_compute_instance" "majority_maker" {

  project = "PROJECT_ID" # example: my-project-x

  # majority_maker_instance_name
  name = "MAJORITY-MAKER" # example: "majority-maker". Must conform to [a-zA-Z][a-zA-Z0-9]{2}.

  # majority_maker_instance_type
  machine_type = "MACHINE_TYPE" # example: n1-standard-8

  # majority_maker_zone
  zone = "ZONE-C" # Should be a different zone than primary and secondary site

  boot_disk {
    initialize_params {
      # majority_maker_linux_image: Use linux_image_project and linux_image from previous section, example: "rhel-sap-cloud/rhel-9-0-sap-v20230711"
      image = "LINUX_IMAGE_PROJECT/LINUX_IMAGE"
    }
  }

  network_interface {
    # network or subnetwork: Should be the same as primary and secondary site
    network = "NETWORK"
  }

  service_account {
    # service_account (OPTIONAL)
    # email  = svc-acct-name@project-id.iam.gserviceaccount.com.

    # Do not edit
    scopes = ["cloud-platform"]
  }

  # Do not edit
  metadata_startup_script = "curl -s https://storage.googleapis.com/cloudsapdeploy/deploymentmanager/latest/dm-templates/sap_majoritymaker/startup.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/deploymentmanager/latest/dm-templates/sap_majoritymaker/startup.sh"
}
