# SAP DB2 Simple Example

This example illustrates how to use the `SAP DB2 ` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_db2/README.md#requirements) for the SAP DB2 Submodule.

The following changes would need to be done in tfvars file :

## Use Case 1: For standalone projects

subnetwork_project = “ “

project_id = “project_id of standalone project”

service_account = “service account email of standalone project”

## Use Case 2: For Shared VPC Projects(Host/Service)

subnetwork_project = “project_id of host project”

project_id = “project_id of service project”

service_account = “service account email of Service Project”

## Setup

1. Create a `terraform.tfvars` in this directory or the directory where you're running this example.
2. Copy `terraform.tfvars.example` content into the `terraform.tfvars` file and update the contents to match your environment.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | `"true"` | no |
| boot\_disk\_size | Root disk size in GB | string | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| db2\_sid | db2 sid | string | n/a | yes |
| db2backup\_size | Db2 backup size | string | n/a | yes |
| db2dump\_size | db2 dump size | string | n/a | yes |
| db2home\_size | db2 home | string | n/a | yes |
| db2log\_size | db2 log size | string | n/a | yes |
| db2log\_ssd | db2 log ssd | string | n/a | yes |
| db2sapdata\_size | Db2 sap data size | string | n/a | yes |
| db2sapdata\_ssd | Db2 sap data ssd. | string | n/a | yes |
| db2saptmp\_size | db2 sap temp size | string | n/a | yes |
| db2sid\_size | DB2 sid size | string | n/a | yes |
| disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE linux image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_standard\_size | Persistant standard disk size in GB | string | n/a | yes |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script | Startup script to install SAP HANA. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| swap\_mnt\_size | SAP mount size | string | n/a | yes |
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
