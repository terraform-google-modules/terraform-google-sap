# SAP HANA Scaleout Simple Example

This example illustrates how to use the `SAP HANA HA` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_hana_scaleout/README.md#requirements) for the SAP HANA Scaleout Submodule.

## Setup

1. Create a `terraform.tfvars` in this directory or the directory where you're running this example.
2. Copy `terraform.tfvars.example` content into the `terraform.tfvars` file and update the contents to match your environment.


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | `"false"` | no |
| boot\_disk\_size | Root disk size in GB. | string | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| disk\_type\_0 | The GCE data disk type. May be set to pd-ssd. | string | `""` | no |
| disk\_type\_1 | The GCE data disk type. May be set to pd-standard (for PD HDD). | string | `""` | no |
| instance\_count\_master | Compute Engine instance count | string | n/a | yes |
| instance\_count\_worker | Compute Engine instance count | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_hdd\_size | Persistent Standard disk size in GB | string | `""` | no |
| pd\_ssd\_size | Persistent disk size in GB | string | `""` | no |
| post\_deployment\_script | SAP post deployment script | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket | string | n/a | yes |
| sap\_hana\_instance\_number | SAP HANA instance number | string | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP HANA SAP System GID | string | `"900"` | no |
| sap\_hana\_scaleout\_nodes | SAP hana scaleout nodes | string | n/a | yes |
| sap\_hana\_sid | SAP HANA System Identifier | string | n/a | yes |
| sap\_hana\_sidadm\_password | SAP hana SID admin password | string | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP HANA System Identifier Admin UID | string | `"900"` | no |
| sap\_hana\_system\_password | SAP hana system password | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script\_1 | Startup script to install SAP HANA. | string | n/a | yes |
| startup\_script\_2 | Startup script to install SAP HANA. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| zone | The zone that the instance should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_master\_name | Name of instance of the master |
| instance\_name | Name of instance |
| instance\_worker\_first\_node\_name | Name of instance of the master |
| instance\_worker\_second\_node\_name | Name of instance of the master |
| sap\_hana\_sid | SAP Hana SID user |
| zone | Compute Engine instance deployment zone |

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
