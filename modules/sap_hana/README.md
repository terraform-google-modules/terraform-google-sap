
# SAP HANA Submodule

This module handles opinionated SAP HANA configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create a Compute Instance that will host SAP HANA
- Create a Static IP Adresse for the Compute Instance
- Create a 2 Persistent Disks to host SAP HANA's File systems

You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 3.13.0"
}

module "gcp_sap_hana" {
  source                 = "terraform-google-modules/sap/google/modules/sap_hana"
  subnetwork                 = var.subnetwork
  linux_image_family         = var.linux_image_family
  linux_image_project        = var.linux_image_project
  instance_name              = var.instance_name
  instance_type              = var.instance_type
  project_id                 = var.project_id
  region                     = var.region
  zone                       = var.zone
  service_account_email      = var.service_account_email
  boot_disk_type             = var.boot_disk_type
  boot_disk_size             = var.boot_disk_size
  autodelete_disk            = "true"
  pd_ssd_size                = var.pd_ssd_size
  pd_hdd_size                = var.pd_hdd_size
  sap_hana_deployment_bucket = var.sap_hana_deployment_bucket
  sap_deployment_debug       = "false"
  post_deployment_script     = var.post_deployment_script
  startup_script             = var.startup_script
  sap_hana_sid               = var.sap_hana_sid
  sap_hana_instance_number   = var.sap_hana_instance_number
  sap_hana_sidadm_password   = var.sap_hana_sidadm_password
  sap_hana_system_password   = var.sap_hana_system_password
  network_tags               = var.network_tags
  sap_hana_sidadm_uid        = 900
  sap_hana_sapsys_gid        = 900
  address_name               = var.address_name
}
```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)

### SAP HANA Software
 Follow instructions [here](https://cloud.google.com/solutions/sap/docs/sap-hana-deployment-guide#creating_a_cloud_storage_bucket_for_the_sap_hana_installation_files) to properly Download SAP HANA from the SAP Marketplace, and upload it to a GCS bucket.


### Configure Service Account for identifying the Compute instance
The compute instance created by this submodule will need to download SAP HANA from a GCS bucket in order install it. Follow the instructions below to ensure a successful installation:

 1. [Create a new service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
 2. Grant this new service account the following permissions on the bucket where you uploaded SAP HANA installation file:
    - Stackdriver Metadata writer: `roles/stackdriver.resourceMetadata.writer`
    - Compute Network admin: `roles/compute.networkAdmin`
    - Log writer: `roles/logging.logWriter`
    - Storage viewer: `roles/storage.objectViewer`

  You may use the following gcloud command:

```shell
ROLES=("roles/stackdriver.resourceMetadata.writer", "roles/compute.networkAdmin", "roles/logging.logWriter", "roles/storage.objectViewer")
for ROLE in ${ROLES[*]}; do
  gcloud projects add-iam-policy-binding <project-id> \
    --member=serviceAccount:<service-account-email> --role=${ROLE}
done
```

3. When configuring the module, use this newly created service account's email, to set the `service_account_email` input variable.

### Post deployment script
If you need to run a post deployment script, the script needs to be accessible via a **https:// or gs:// URl**.
The recommended way is to use a GCS Bucket in the following way.:

1. Upload the post-deployment-script to a GCS bucket.
2. Grant the following role on the bucket to the service account attached to the instance if the bucket is not in the same project as the service account:
   - Storage Object Viewer: `roles/storage.objectViewer`

 3. Set the value of the `post_deployment_script` input to the URI of the post-deployment script storage bucket object, like `gs://<bucket_name>/<script_name>`.


[^]: (autogen_docs_start)

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_name | Name of static IP adress to add to the instance's access config. | `string` | `""` | no |
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | `string` | `"false"` | no |
| boot\_disk\_size | Root disk size in GB. | `any` | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | `any` | n/a | yes |
| device\_name\_pd\_hdd | device name for standard persistant disk | `string` | `"backup"` | no |
| device\_name\_pd\_ssd | device name for ssd persistant disk | `string` | `"pdssd"` | no |
| disk\_name\_0 | Name of first disk. | `string` | `"sap-hana-pd-sd-0"` | no |
| disk\_name\_1 | Name of second disk. | `string` | `"sap-hana-pd-sd-1"` | no |
| disk\_type\_0 | The GCE data disk type. May be set to pd-ssd. | `string` | `"pd-ssd"` | no |
| disk\_type\_1 | The GCE data disk type. May be set to pd-standard (for PD HDD). | `string` | `"pd-standard"` | no |
| host\_project\_id | Shared VPC only - The ID of the host project containing the Shared VPC network. | `string` | `""` | no |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | `any` | n/a | yes |
| instance\_type | The GCE instance/machine type. | `any` | n/a | yes |
| linux\_image\_family | GCE image family. | `any` | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | `any` | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | `list` | `[]` | no |
| pd\_hdd\_size | Persistent disk size in GB. | `string` | `""` | no |
| pd\_kms\_key | Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used.. | `any` | `null` | no |
| pd\_ssd\_size | Persistent disk size in GB. | `string` | `""` | no |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | `string` | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | `any` | n/a | yes |
| public\_ip | Determines whether a public IP address is added to your VM instance. | `bool` | `true` | no |
| region | Region to deploy the resources. Should be in the same region as the zone. | `any` | n/a | yes |
| sap\_deployment\_debug | Debug flag for SAP HANA deployment. | `string` | `"false"` | no |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket. | `any` | n/a | yes |
| sap\_hana\_instance\_number | SAP HANA instance number | `any` | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP HANA SAP System GID | `any` | n/a | yes |
| sap\_hana\_sid | SAP HANA System Identifier. When using the SID to enter a user session, like this for example, `su - [SID]adm`, make sure that [SID] is in lower case. | `any` | n/a | yes |
| sap\_hana\_sidadm\_password | SAP HANA System Identifier Admin password | `any` | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP HANA System Identifier Admin UID | `any` | n/a | yes |
| sap\_hana\_system\_password | SAP HANA system password | `any` | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | `any` | n/a | yes |
| startup\_script | Startup script to install SAP HANA. | `any` | n/a | yes |
| subnetwork | The name or self\_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | `any` | n/a | yes |
| zone | The zone that the instance should be created in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | n/a |
| machine\_type | n/a |
| zone | n/a |

[^]: (autogen_docs_end)
