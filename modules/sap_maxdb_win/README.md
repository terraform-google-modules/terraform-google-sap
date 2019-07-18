
# SAP MaxdB Window Submodule

This module handles opinionated SAP MaxDB configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create a Compute Instance that will host SAP MaxDB window
- Create a Static IP Address for the Compute Instance
- Create a 2 Persistent Disks to host SAP MaxDB's window File systems.

You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 2.6.0"
}

module "gcp_sap_maxdb_win" {
  source                 = "terraform-google-modules/sap/google/modules/sap_maxdb_win"
  subnetwork            = "${var.subnetwork}"
  windows_image_family   = "${var.windows_image_family}"
  windows_image_project  = "${var.windows_image_project}"
  instance_name         = "${var.instance_name}"
  address_name         = "${var.address_name}"
  instance_type         = "${var.instance_type}"
  zone                  = "${var.zone}"
  network_tags          = "${var.network_tags}"
  region                = "${var.region}"
  service_account_email = "${var.service_account_email}"
  boot_disk_size        = "${var.boot_disk_size}"
  boot_disk_type        = "${var.boot_disk_type}"
  disk_type_0             = "${var.disk_type_0}"
  disk_type_1           = "${var.disk_type_1}"
  autodelete_disk       = "${var.autodelete_disk}"
  pd_ssd_size           = "${var.pd_ssd_size}"
  pd_hdd_size      = "${var.pd_hdd_size}"
  usr_sap_size          = "${var.usr_sap_size}"
  swap_size             = "${var.swap_size}"
  maxdbRootSize         = "${var.maxdbRootSize}"
  maxdbDataSize         = "${var.maxdbDataSize}"
  maxdbLogSize          = "${var.maxdbLogSize}"
  maxdbBackupSize       = "${var.maxdbBackupSize}"
  maxdbDataSSD          = "${var.maxdbDataSSD}"
  maxdbLogSSD           = "${var.maxdbLogSSD}"
  swapmntSize           = "${var.swapmntSize}"
  sap_maxdb_sid         = "${var.sap_maxdb_sid}"
  startup_script        = "${var.startup_script}"
}
```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)

### Configure Service Account for identifying the Compute instance
The compute instance created by this submodule will need to download SAP MaxDB from a GCS bucket in order install it. Follow the instructions below to ensure a successful installation:

 1. [Create a new service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
 2. Grant this new service account the following permissions on the bucket where you uploaded SAP HANA installation file:
    - Storage Object Viewer: `roles/storage.objectViewer`

  You may use the following gcloud command:
  `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.objectViewer`

3. When configuring the module, use this newly created service account's email, to set the `service_account_email` input variable.

### Post deployment script
If you need to run a post deployment script, the script needs to be accessible via a **https:// or gs:// URl**.
The recommended way is to use a GCS Bucket in the following way.:

1. Upload the post-deployment-script to a GCS bucket.
2. Grant the following role on the bucket to the service account attached to the instance if the bucket is not in the same project as the service account:
   - Storage Object Viewer: `roles/storage.objectViewer`

 3. Set the value of the `post_deployment_script` input to the URI of the post-deployment script storage bucket object, like `gs://<bucket_name>/<script_name>`.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| address\_name | Name of static IP adress to add to the instance's access config. | string | n/a | yes |
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | `"false"` | no |
| boot\_disk\_size | Root disk size in GB. | string | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| device | Device name | string | `"boot"` | no |
| device\_0 | Device name | string | `"usrsap"` | no |
| device\_1 | Device name | string | `"swap"` | no |
| device\_2 | Device name | string | `"maxdbroot"` | no |
| device\_3 | Device name | string | `"maxdblog"` | no |
| device\_4 | Device name | string | `"maxdbdata"` | no |
| device\_5 | Device name | string | `"maxdbbackup"` | no |
| device\_6 | Device name | string | `"sapmnt"` | no |
| disk\_name\_0 | Name of first disk. | string | `"sap-maxdb-pd-sd-0"` | no |
| disk\_name\_1 | Name of second disk. | string | `"sap-maxdb-pd-sd-1"` | no |
| disk\_name\_2 | Name of third disk. | string | `"sap-maxdb-pd-sd-2"` | no |
| disk\_name\_3 | Name of fourth disk. | string | `"sap-maxdb-pd-sd-3"` | no |
| disk\_name\_4 | Name of fifth disk. | string | `"sap-maxdb-pd-sd-4"` | no |
| disk\_name\_5 | Name of sixth disk. | string | `"sap-maxdb-pd-sd-5"` | no |
| disk\_name\_6 | Name of seventh disk. | string | `"sap-maxdb-pd-sd-6"` | no |
| disk\_type\_0 | The GCE data disk type. May be set to pd-ssd. | string | n/a | yes |
| disk\_type\_1 | The GCE data disk type. May be set to pd-standard (for PD HDD). | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| maxdbBackupSize | The size of the Backup (X:) volume. | string | n/a | yes |
| maxdbDataSSD | Specifies whether the data drive uses an SSD persistent disk (Yes) or an HDD persistent disk (No). | string | n/a | yes |
| maxdbDataSize | The size of MaxDB Data (E:), which holds the database data files. | string | n/a | yes |
| maxdbLogSSD | Specifies whether the log drive uses an SSD persistent disk (Yes) or an HDD persistent disk (No). | string | n/a | yes |
| maxdbLogSize | The size of MaxDB Log (L:), which holds the database transaction logs. | string | n/a | yes |
| maxdbRootSize | The size in GB of MaxDB (D:), which is the root directory of the database instance. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_hdd\_size | Persistent standard disk size in GB | string | `""` | no |
| pd\_ssd\_size | Persistent ssd disk size in GB. | string | `""` | no |
| post\_deployment\_script | SAP Maxdb post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_deployment\_debug | Debug flag for SAP Maxdb deployment. | string | `"false"` | no |
| sap\_maxdb\_sid | sap max db sid | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| swap\_size | SWAP Size | string | n/a | yes |
| swapmntSize | SAP mount size | string | n/a | yes |
| usr\_sap\_size | USR SAP size | string | n/a | yes |
| windows\_image\_family | Compute Engine image name | string | n/a | yes |
| windows\_image\_project | Project name containing the linux image | string | n/a | yes |
| zone | The zone that the instance should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name |  |
| machine\_type |  |
| zone |  |

[^]: (autogen_docs_end)
