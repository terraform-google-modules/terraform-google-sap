
# Netweaver Submodule

This module is handles opinionated Netweaver configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create a Compute Instance that will host Netweaver
- Create a Static IP Addresses for the Compute Instance
- Create a 2 Persitent Disks to host Netweaver's File systems

You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 3.13.0"
}

module "gcp_netweaver" {
  source                 = "terraform-google-modules/sap/google/modules/netweaver"
  subnetwork             = var.subnetwork
  linux_image_family     = var.linux_image_family
  linux_image_project    = var.linux_image_project
  autodelete_disk        = "true"
  public_ip              = var.public_ip
  sap_deployment_debug   = var.sap_deployment_debug
  usr_sap_size           = var.usr_sap_size
  sap_mnt_size           = var.sap_mnt_size
  swap_size              = var.swap_size
  instance_name          = var.instance_name
  instance_type          = var.instance_type
  region                 = var.region
  network_tags           = var.network_tags
  project_id             = var.project_id
  zone                   = var.zone
  service_account_email  = var.service_account_email
  boot_disk_size         = var.boot_disk_size
  boot_disk_type         = var.boot_disk_type
  disk_type              = var.disk_type
  startup_script         = var.startup_script
}

```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)


### Configure Service Account for identifying the Compute instance
The compute instance created by this submodule will need to download SAP HANA from a GCS bucket in order install it. Follow the instructions below to ensure a successful installation:

 1. [Create a new service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
 2. Grant this new service account the following permissions on the bucket where you uploaded netweaver file:

  - Storage Admin: `roles/compute.storageAdmin`

  You may use the following gcloud command:
  `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/compute.storageAdmin`

  - Compute Instance Admin (v1) : `roles/compute.instanceAdmin.v1`

  You may use the following gcloud command:
  `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/compute.instanceAdmin.v1`

  - Compute Network Admin : `roles/compute.networkAdmin`

  You may use the following gcloud command:
  `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/compute.networkAdmin`

  - Compute Security Admin : `rolescompute.securityAdmin`

  You may use the following gcloud command:
  `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=rolescompute.securityAdmin`

  - Service Account User :`roles/iam.serviceAccountUser`

 You may use the following gcloud command:
`gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/iam.serviceAccountUser`

  - Logs Writer : `roles/logging.logWriter`

  You may use the following gcloud command:
`gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/logging.logWriter`

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
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | `string` | `"false"` | no |
| boot\_disk\_size | Root disk size in GB. | `any` | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | `any` | n/a | yes |
| can\_ip\_forward | Allow IP forwarding for the instance | `bool` | `true` | no |
| device\_0 | Device name | `string` | `"boot"` | no |
| device\_1 | Device name | `string` | `"usrsap"` | no |
| device\_2 | Device name | `string` | `"sapmnt"` | no |
| device\_3 | Device name | `string` | `"swap"` | no |
| disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | `any` | n/a | yes |
| instance\_internal\_ip | Instance private ip address | `string` | `""` | no |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | `any` | n/a | yes |
| instance\_type | The GCE instance/machine type. | `any` | n/a | yes |
| linux\_image\_family | GCE image family. | `any` | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | `any` | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | `list` | `[]` | no |
| pd\_kms\_key | Customer managed encryption key to use in persistent disks. If none provided, a Google managed key will be used. | `any` | `null` | no |
| post\_deployment\_script | Netweaver post deployment script. Must be a gs:// or https:// link to the script. | `string` | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | `any` | n/a | yes |
| public\_ip | Determines whether a public IP address is added to your VM instance. | `number` | `1` | no |
| region | Region to deploy the resources. Should be in the same region as the zone. | `any` | n/a | yes |
| sap\_deployment\_debug | Debug flag for Netweaver deployment. | `string` | `"false"` | no |
| sap\_mnt\_size | SAP mount size | `any` | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | `any` | n/a | yes |
| startup\_script | This will reference the startup.sh script files in the files folder for netweaver set up in the instance | `any` | n/a | yes |
| subnetwork | The name or self\_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | `any` | n/a | yes |
| swap\_size | SWAP Size | `any` | n/a | yes |
| usr\_sap\_size | USR SAP size | `any` | n/a | yes |
| zone | The zone that the instance should be created in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_machine\_type | Primary GCE instance/machine type. |
| instance\_name | Name of Netweaver instance |
| zone | Compute Engine instance deployment zone |

[^]: (autogen_docs_end)
