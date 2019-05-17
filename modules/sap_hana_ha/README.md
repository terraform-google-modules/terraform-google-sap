
# SAP HANA HA Submodule

This module deals with SAP HANA HA configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create Primary and Secondary Compute Instance that will host SAP HANA.
- Create a Static IP Address for the two Compute Instance's.
- Create 2 Persistent Disks to host SAP HANA's File systems on primary and secondary nodes.

You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 2.6.0"
  region  = "${var.region}"
}

module "gcp_sap_hana_ha" {
  source                     = "terraform-google-modules/sap/google/modules/sap_hana_ha"
  subnetwork                 = "${var.subnetwork}"
  linux_image_family         = "${var.linux_image_family}"
  linux_image_project        = "${var.linux_image_project}"
  instance_name              = "${var.instance_name}"
  instance_type              = "${var.instance_type}"
  disk_type                  = "${var.boot_disk_type}"
  project_id                 = "${var.project_id}"
  region                     = "${var.region}"
  service_account_email      = "${var.service_account_email}"
  boot_disk_type             = "pd-ssd"
  boot_disk_size             = "${var.boot_disk_size}"
  autodelete_disk            = "${var.autodelete_disk}"
  pd_ssd_size                = "${var.pd_ssd_size}"
  sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
  sap_deployment_debug       = "false"
  post_deployment_script     = "${var.post_deployment_script}"
  startup_script_1           = "${var.startup_script_1}"
  startup_script_2           = "${var.startup_script_2}"
  sap_hana_sid               = "${var.sap_hana_sid}"
  sap_hana_instance_number   = "${var.sap_hana_instance_number}"
  sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
  sap_hana_system_password   = "${var.sap_hana_system_password}"
  sap_hana_sidadm_uid        = "${var.sap_hana_sidadm_uid}"
  sap_hana_sapsys_gid        = "${var.sap_hana_sapsys_gid}"
  }
```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)

### SAP HANA Software
 Follow instructions [here](https://cloud.google.com/solutions/sap/docs/sap-hana/sap-hana-ha-deployment-guide#creating_a_cloud_storage_bucket_for_the_sap_hana_installation_files) to properly Download SAP HANA from the SAP Marketplace, and upload it to a GCS bucket.


### Configure Service Account for identifying the Compute instance
The compute instance created by this submodule will need to download SAP HANA from a GCS bucket in order install it. Follow the instructions below to ensure a successful installation:

 1. [Create a new service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
 2. Grant this new service account the following permissions on the bucket where you uploaded SAP HANA installation file:
    - roles/storage.objectViewer

 You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.objectViewer`

3. When configuring the module, use this newly created service account's email, to set the `service_account_email` input variable.

### Post deployment script
If you need to run a post deployment script, the script needs to be accessible via a **https:// or gs:// URl**.
It is the recommended way is to use a GCS Bucket in the following way.:

1. Upload the to a GCS bucket.
2. Make sure the service account attached to the instance has the following permissions on the bucket:
   - roles/storage.objectViewer
     - Note that this permission should already be granted if the bucket is in the same project as the one where you created the service account previously.

3. Set the post_deployment_script input to the gs:// link to your script. (i.e gs://<bucket_name>/<my_script>)


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| address\_name | Name of static IP adress to add to the instance's access config. | string | n/a | yes |
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | n/a | yes |
| boot\_disk\_size | Root disk size in GB. | string | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| disk\_name\_0 | Name of first disk. | string | n/a | yes |
| disk\_name\_1 | Name of second disk. | string | n/a | yes |
| disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB. | string | n/a | yes |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_deployment\_debug | Debug flag for SAP HANA deployment. | string | n/a | yes |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket. | string | n/a | yes |
| sap\_hana\_instance\_number | SAP HANA instance number | string | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP HANA SAP System GID | string | n/a | yes |
| sap\_hana\_sid | SAP HANA System Identifier | string | n/a | yes |
| sap\_hana\_sidadm\_password | SAP HANA System Identifier Admin password | string | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP HANA System Identifier Admin UID | string | n/a | yes |
| sap\_hana\_system\_password | SAP HANA system password | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script |  Primary and Secondary startup script's to install SAP HANA. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| zone(primary & secondary) | The two zone's that the instance's should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_hana\_id | SAP Hana SID user |
| project\_id | The ID of the project in which resources are provisioned. |
| primary\_instance | Name of sap primary instance |
| secondary\_instance | Name of sap secondary instance  |
| primary\_zone | Compute Engine primary instance deployment zone  |
| secondary\_zone | Compute Engine primary instance deployment zone |

[^]: (autogen_docs_end)
