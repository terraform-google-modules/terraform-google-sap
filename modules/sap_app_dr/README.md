
# SAP APP DR Submodule

This module handles opinionated SAP APP DR configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create a Compute Instance that whill host SAP HANA
- Create a Static IP Adresse for the Compute Instance
- Create a 2 Persistent Disks to host SAP App Dr's File systems

You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 2.6.0"
}

module "gcp_sap_app_dr" {
  source                 = "terraform-google-modules/sap/google/modules/sap_app_dr"
  subnetwork            = "${var.subnetwork}"
  instance_name         = "${var.instance_name}"
  instance_type         = "${var.instance_type}"
  project_id            = "${var.project_id}"
  region                = "${var.region}"
  service_account_email = "${var.service_account_email}"
  address_name          = "${var.address_name}"
  zone_1                = "${var.zone_1}"
  zone_2                = "${var.zone_2}"
  usc_class             = "${var.usc_class}"
  scs_user              = "${var.scs_user}"
  sap_user              = "${var.sap_user}"
  network_tags          = "${var.network_tags}"
  disk_type             = "${var.disk_type}"
  pd_ssd_size           = "${var.pd_ssd_size}"
  snapshot_name_0       = "${var.snapshot_name_0}"
  snapshot_name_1       = "${var.snapshot_name_1}"
  snapshot_name_2       = "${var.snapshot_name_2}"
  source_disk_0         = "${var.source_disk_0}"
  source_disk_1         = "${var.source_disk_1}"
  source_disk_2         = "${var.source_disk_2}"
}

```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)



### Configure Service Account for identifying the Compute instance
The compute instance created by this submodule will need to download SAP APP DRfrom a GCS bucket in order install it. Follow the instructions below to ensure a successful installation:

 1. [Create a new service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
 2. Grant this new service account the following permissions on the bucket where you uploaded SAP APP DRinstallation file:
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
| disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | n/a | yes |
| pd\_ssd\_size | Persistent disk size in GB | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_user | Second disk created from snapshot | string | n/a | yes |
| scs\_user | Third disk created from snapshot | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| snapshot\_name\_0 | First Snapshot name | string | n/a | yes |
| snapshot\_name\_1 | Second Snapshot name | string | n/a | yes |
| snapshot\_name\_2 | Third Snapshot name | string | n/a | yes |
| source\_disk\_0 | First Source Disk | string | n/a | yes |
| source\_disk\_1 | Second Source Disk | string | n/a | yes |
| source\_disk\_2 | Third Source Disk | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| usc\_class | First disk created from snapshot | string | n/a | yes |
| zone\_1 | The zone that the instance should be created in. | string | n/a | yes |
| zone\_2 | The zone that the instance should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | Name of instance |
| zone\_1 | Compute Engine instance deployment zone |
| zone\_2 | Compute Engine instance deployment zone |

[^]: (autogen_docs_end)
