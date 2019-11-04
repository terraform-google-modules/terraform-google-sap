# SAP ASE Simple Example

This example illustrates how to use the `SAP ASE` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_ase/README.md#requirements) for the SAP ASE Submodule.

## Setup

1. Create a `terraform.tfvars` in this directory or the directory where you're running this example.
2. Copy `terraform.tfvars.example` content into the `terraform.tfvars` file and update the contents to match your environment.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aseSID | The database instance ID. | string | n/a | yes |
| asebackupSize | The size of the /sybasebackup volume. If set to 0 or omitted, no disk is created. | string | n/a | yes |
| asediagSize | The size of /sybase/[DBSID]/sapdiag, which holds the diagnostic tablespace for SAPTOOLS. | string | n/a | yes |
| aselogSSD | The SSD toggle for the log drive. If set to true, the log disk will be SSD. | string | n/a | yes |
| aselogSize | The size of /sybase/[DBSID]logdir, which holds the database transaction logs. | string | n/a | yes |
| asesapdataSSD | The SSD toggle for the data drive. If set to true, the data disk will be SSD. | string | n/a | yes |
| asesapdataSize | The size of /sybase/[DBSID]/sapdata, which holds the database data files. | string | n/a | yes |
| asesaptempSize | The size of /sybase/[DBSID]/saptmp, which holds the database temporary table space. | string | n/a | yes |
| asesidSize | The size in GB of /sybase/[DBSID], which is the root directory of the database instance. In the deployed VM, this volume is labeled ASE. | string | n/a | yes |
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | `"true"` | no |
| boot\_disk\_size | Root disk size in GB | string | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | `"pd-ssd"` | no |
| device\_0 | Device name | string | `"usrsap"` | no |
| device\_1 | Device name | string | `"sapmnt"` | no |
| device\_2 | Device name | string | `"swap"` | no |
| device\_3 | Device name | string | `"asesid"` | no |
| device\_4 | Device name | string | `"asesapdata"` | no |
| device\_5 | Device name | string | `"aselog"` | no |
| device\_6 | Device name | string | `"asesaptemp"` | no |
| device\_7 | Device name | string | `"asesapdiag"` | no |
| device\_8 | Device name | string | `"asebackup"` | no |
| disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| instance\_count\_master | Compute Engine instance count | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE linux image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB | string | `""` | no |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_ase\_sid | Sap Ase SID. | string | n/a | yes |
| sap\_mnt\_size | SAP mount size | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script | Startup script to install SAP HANA. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| swap\_size | SWAP Size | string | n/a | yes |
| usr\_sap\_size | USR SAP size | string | n/a | yes |
| zone | The zone that the instance should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | Name of instance |
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
