# SAP Empty HA  Simple Example

This example illustrates how to use the `SAP HANA EMPTY HA` submodule to deploy SAP HANA EMPTY HA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_hana_emptyha/README.md#requirements) for the SAP HANA EMPTY HA Submodule.

## Setup

1. Create a `terraform.tfvars` in this directory or the directory where you're running this example.
2. Copy `terraform.tfvars.example` content into the `terraform.tfvars` file and update the contents to match your environment.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| boot\_disk\_size | Root disk size in GB | string | n/a | yes |
| boot\_disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| primary\_instance\_ip | Primary instance ip address | string | n/a | yes |
| primary\_instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | no |
| primary\_zone | The primary zone that the instance should be created in. | string | n/a | yes |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_hana\_deployment\_bucket | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | string | n/a | yes |
| sap\_vip | SAP VIP | string | n/a | yes |
| sap\_vip\_internal\_address | Name of static IP adress to add to the instance's access config. | string | n/a | yes |
| sap\_vip\_secondary\_range | SAP seconday VIP range | string | n/a | yes |
| secondary\_instance\_ip | Secondary instance ip address | string | n/a | yes |
| secondary\_instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a| no |
| secondary\_zone | The secondary zone that the instance should be created in. | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| subnetwork | Compute Engine instance name | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| primary\_instance\_name | Name of sap primary instance |
| secondary\_instance\_name | Name of sap secondary instance |

[^]: (autogen_docs_end)

## Running the example

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


## Integration Tests

If you need to run integration tests make sure to go through these additional setup steps.


### Additional APIs
 a project with the additional following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage.googleapis.com`


### Additional Service Account Permissions
If you need to run integration tests, the service for deploying resources needs the following additional permissions:

- roles/storage.admin

 You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.admin`

### Running integration tests

Refer to the [contributing guidelines' Integration Testing Section](../../CONTRIBUTING.md#integration-test) for running integration tests for this example.
