# SAP HANA HA Simple Example

This example illustrates how to use the `SAP HANA HA` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_hana_ha/README.md#requirements) for the SAP HANA HA Submodule.

## Setup

1. Create a `terraform.tfvars` in this directory or the directory where you're running this example.
2. Copy `terraform.tfvars.example` content into the `terraform.tfvars` file and update the contents to match your environment.


[^]: (autogen_docs_start)

## Requirements

| Name | Version |
|------|---------|
| google | ~> 3.13.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.13.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| boot\_disk\_size | Root disk size in GB | `any` | n/a | yes |
| boot\_disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | `any` | n/a | yes |
| can\_ip\_forward | Allow IP forwarding for the instance | `bool` | `true` | no |
| instance\_type | The GCE instance/machine type. | `any` | n/a | yes |
| linux\_image\_family | GCE image family. | `any` | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | `any` | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | `list` | `[]` | no |
| pd\_hdd\_size | Persistent disk size in GB. | `string` | `""` | no |
| pd\_ssd\_size | Persistent disk size in GB | `string` | `""` | no |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | `string` | `""` | no |
| primary\_instance\_internal\_ip | Primary instance private ip address | `string` | `""` | no |
| primary\_instance\_ip | Primary instance ip address | `string` | `""` | no |
| primary\_instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | `any` | n/a | yes |
| primary\_zone | The primary zone that the instance should be created in. | `any` | n/a | yes |
| project\_id | The ID of the project in which the resources will be deployed. | `any` | n/a | yes |
| public\_ip | Determines whether a public IP address is added to your VM instance. | `bool` | `true` | no |
| region | Region to deploy the resources. Should be in the same region as the zone. | `any` | n/a | yes |
| sap\_hana\_deployment\_bucket | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | `any` | n/a | yes |
| sap\_hana\_instance\_number | SAP HANA instance number | `any` | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP HANA SAP System GID | `any` | n/a | yes |
| sap\_hana\_sid | SAP HANA System Identifier | `any` | n/a | yes |
| sap\_hana\_sidadm\_password | SAP HANA System Identifier Admin password | `any` | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP HANA System Identifier Admin UID | `any` | n/a | yes |
| sap\_hana\_system\_password | SAP HANA system password | `any` | n/a | yes |
| sap\_vip | SAP VIP | `any` | n/a | yes |
| sap\_vip\_internal\_address | Name of static IP adress to add to the instance's access config. | `any` | n/a | yes |
| sap\_vip\_secondary\_range | SAP seconday VIP range | `any` | n/a | yes |
| secondary\_instance\_internal\_ip | Secondary instance private ip address | `string` | `""` | no |
| secondary\_instance\_ip | Secondary instance ip address | `string` | `""` | no |
| secondary\_instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | `any` | n/a | yes |
| secondary\_zone | The secondary zone that the instance should be created in. | `any` | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | `any` | n/a | yes |
| startup\_script\_1 | Startup script to install SAP HANA. | `any` | n/a | yes |
| startup\_script\_2 | Startup script to install SAP HANA. | `any` | n/a | yes |
| subnetwork | Compute Engine instance name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| primary\_instance\_name | Name of sap primary instance |
| sap\_hana\_sid | SAP Hana SID user |
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
