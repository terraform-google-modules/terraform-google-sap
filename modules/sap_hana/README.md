
# SAP HANA Submodule

This module is handles opinionated SAP HANA configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create a Compute Instance that whill host SAP HANA
- Create a Static IP Adresse for the Compute Instance
- Create a 2 Persitent Disks to host SAP HANA's File systems

You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 1.18.0"
  region  = "${var.region}"
}

module "gcp_sap_hana" {
  source                 = "terraform-google-modules/sap/google/modules/sap_hana"
  subnetwork             = "${var.subnetwork}"
  linux_image_family     = "sles-12-sp3-sap"
  linux_image_project    = "suse-sap-cloud"
  instance_name          = "${var.instance_name}"
  instance_type          = "n1-highmem-16"
  disk_type              = "pd-ssd"
  project_id             = "${var.project_id}"
  region                 = "${var.region}"
  service_account_email        = "${var.service_account_email}"
  boot_disk_type         = "pd-ssd"
  boot_disk_size         = 64
  autodelete_disk        = "true"
  pd_ssd_size            = 450

  sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
  sap_deployment_debug       = "false"
  post_deployment_script = "${var.post_deployment_script}"

  startup_script           = "${var.startup_script}"
  startup_script_custom    = "${var.startup_script_custom}"
  sap_hana_sid             = "D10"
  sap_hana_instance_number = 10
  sap_hana_sidadm_password = "Google123"
  sap_hana_system_password = "Google123"
  sap_hana_sidadm_uid      = 900
  sap_hana_sapsys_gid      = 900
}
```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)

### SAP HANA Software
 Follow instructions [here](https://cloud.google.com/solutions/sap/docs/sap-hana-deployment-guide#creating_a_cloud_storage_bucket_for_the_sap_hana_installation_files) to properly Download SAP HANA from the SAP Marketplace, and upload it to a GCS bucket.


### Configure Service Account for identifying the Compute instance
The compute instance created by this submodule will need to download SAP HANA from a GCS bucket in order install. Follow the instructions below to ensure a successful installation:

 1. Create a new service account
 2. Grant the new service account the following permissions on the bucket where you uploaded SAP HANA installation file:
 - roles/storage.objectViewer

 You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.objectViewer`

3. When configuring the module, use this newly created service account's email, to set the `service_account_email` input variable.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autodelete\_disk | Delete backend disk along with instance | string | `"true"` | no |
| boot\_disk\_size | Root disk size in GB | string | n/a | yes |
| boot\_disk\_type | The type of data disk: PD_SSD or PD_HDD. | string | n/a | yes |
| instance\_name | Compute Engine instance name | string | n/a | yes |
| instance\_type | Compute Engine instance Type | string | n/a | yes |
| linux\_image\_family | Compute Engine image name | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image | string | n/a | yes |
| network\_tags | List of network tags | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB | string | n/a | yes |
| pd\_standard\_size | Persistent disk size in GB | string | n/a | yes |
| post\_deployment\_script | SAP post deployment script | string | n/a | yes |
| project\_id | Project id to deploy the resources | string | n/a | yes |
| region | Region to deploy the resources | string | n/a | yes |
| sap\_deployment\_debug | SAP hana deployment debug | string | `"false"` | no |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket | string | n/a | yes |
| sap\_hana\_instance\_number | SAP hana instance number | string | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP hana sap system gid | string | n/a | yes |
| sap\_hana\_sid | SAP hana SID | string | n/a | yes |
| sap\_hana\_sidadm\_password | SAP hana SID admin password | string | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP hana sid adm password | string | n/a | yes |
| sap\_hana\_system\_password | SAP hana system password | string | n/a | yes |
| service\_account | Service to run the terrform | string | n/a | yes |
| subnetwork | Compute Engine instance name | string | n/a | yes |
| zone | Compute Engine instance deployment zone | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gcp\_sap\_hana\_instance\_machine\_type |  |
| instance\_gcp\_sap\_hana\_name |  |
| instance\_zone |  |

[^]: (autogen_docs_end)
