# SAP HANA Simple Example

This example illustrates how to use the `SAP HANA` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_hana/README.md#requirements) for the SAP HANA Submodule

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| address\_name | Name of static IP adress to add to the instance's access config. | string | `"gcp-sap-hana-ip"` | no |
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | `"true"` | no |
| boot\_disk\_size | Root disk size in GB | string | `"64"` | no |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | `"pd-ssd"` | no |
| disk\_type | The GCE data disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | `"sap-hana-simple-example"` | no |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE linux image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image. | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB | string | `"450"` | no |
| post\_deployment\_script | SAP HANA post deployment script. Must be a gs:// or https:// link to the script. | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | `"us-central1"` | no |
| sap\_deployment\_debug | Debug flag for SAP HANA deployment. | string | `"false"` | no |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket. | string | n/a | yes |
| sap\_hana\_instance\_number | SAP HANA instance number | string | `"10"` | no |
| sap\_hana\_sapsys\_gid | SAP HANA SAP System GID | string | `"900"` | no |
| sap\_hana\_sid | SAP HANA System Identifier | string | `"D10"` | no |
| sap\_hana\_sidadm\_password | SAP HANA System Identifier Admin password | string | `"Google123"` | no |
| sap\_hana\_sidadm\_uid | SAP HANA System Identifier Admin UID | string | `"900"` | no |
| sap\_hana\_system\_password | SAP HANA system password | string | `"Google123"` | no |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script | Startup script to install SAP HANA. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| zone | The zone that the instance should be created in. | string | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | Name of instance |
| sap\_hana\_sid | SAP Hana SID user |
| zone | Compute Engine instance deployment zone |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


## Integration Tests

### Additional Service Account Permissions
If you need to run integration tests, the service for deploying resources needs the following additional permissions:

- roles/storage.admin

 You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.admin`

### Running integration tests

Refer to the [contributing guidelines' Integration Testing Section](../../CONTRIBUTING.md#integration-test) for running integration tests for this example.
