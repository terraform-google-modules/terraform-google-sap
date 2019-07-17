# SAP MaxDB Simple Example

This example illustrates how to use the `SAP MaxDB` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_maxdb/README.md#requirements) for the SAP HANA Submodule.

## Setup

1. Create a `terraform.tfvars` in this directory or the directory where you're running this example.
2. Copy `terraform.tfvars.example` content into the `terraform.tfvars` file and update the contents to match your environment.


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
| linux\_image\_family | GCE image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | string | n/a | yes |
| maxdbBackupSize | The size of the Backup (X:) volume. | string | n/a | yes |
| maxdbDataSSD | Specifies whether the data drive uses an SSD persistent disk (Yes) or an HDD persistent disk (No). | string | n/a | yes |
| maxdbDataSize | The size of MaxDB Data (E:), which holds the database data files. | string | n/a | yes |
| maxdbLogSSD | Specifies whether the log drive uses an SSD persistent disk (Yes) or an HDD persistent disk (No). | string | n/a | yes |
| maxdbLogSize | The size of MaxDB Log (L:), which holds the database transaction logs. | string | n/a | yes |
| maxdbRootSize | The size in GB of MaxDB (D:), which is the root directory of the database instance. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB. | string | `""` | no |
| pd\_standard\_size | Persistent disk size in GB | string | `""` | no |
| post\_deployment\_script | SAP Maxdb post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_deployment\_debug | Debug flag for SAP Maxdb deployment. | string | `"false"` | no |
| sap\_maxdb\_sid | sap max db sid | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script | Startup script to install SAP Maxdb. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| swap\_size | SWAP Size | string | n/a | yes |
| swapmntSize | SAP mount size | string | n/a | yes |
| usr\_sap\_size | USR SAP size | string | n/a | yes |
| zone | The zone that the instance should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | Name of instance |
| sap\_maxdb\_sid | SAP maxdb SID user |
| zone | Compute Engine instance deployment zone |

[^]: (autogen_docs_end)

## Running the example

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


## Integration Tests


### Additonal setup
If you need to run integration tests make sure to go through these additional setup steps.


#### Additional APIs
 A project with the additional following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`


#### Additional Service Account Permissions
If you need to run integration tests, the service for deploying resources needs the following additional permissions:

- Storage Admin: `roles/storage.admin`

The [IAM module][iam-module] may be used in to provision a
service account with the necessary roles applied.

 However, for a quick setup, you can use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.admin`

### Running integration tests

Refer to the [contributing guidelines' Integration Testing Section](../../CONTRIBUTING.md#integration-test) for running integration tests for this example.
