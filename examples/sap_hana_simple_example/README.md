# SAP HANA Simple Example

This example illustrates how to use the `SAP HANA` submodule to deploy SAP HANA on GCP.

## Requirements
Make sure you go through this [Requirements section](../../modules/sap_hana/README.md#requirements) for the SAP HANA Submodule

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autodelete\_disk | Delete backend disk along with instance | string | `"true"` | no |
| boot\_disk\_size | Root disk size in GB | string | `"64"` | no |
| boot\_disk\_type | The type of data disk: PD_SSD or PD_HDD. | string | `"pd-ssd"` | no |
| instance\_name | Compute Engine instance name | string | `"sap-hana-simple-example"` | no |
| instance\_type | Compute Engine instance Type | string | n/a | yes |
| linux\_image\_family | Compute Engine image name | string | `"sles-12-sp3-sap"` | no |
| linux\_image\_project | Project name containing the linux image | string | `"suse-sap-cloud"` | no |
| network\_tags | List of network tags | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB | string | `"50"` | no |
| pd\_standard\_size | Persistent disk size in GB | string | `"50"` | no |
| post\_deployment\_script | SAP post deployment script | string | `""` | no |
| project\_id | Project name to deploy the resources | string | n/a | yes |
| region | Region to deploy the resources | string | `"us-central1"` | no |
| sap\_deployment\_debug | SAP hana deployment debug | string | `"false"` | no |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket | string | `""` | no |
| sap\_hana\_instance\_number | SAP hana instance number | string | `"10"` | no |
| sap\_hana\_sapsys\_gid | SAP hana sap system gid | string | `"900"` | no |
| sap\_hana\_sid | SAP hana SID | string | `"D10"` | no |
| sap\_hana\_sidadm\_password | SAP hana SID admin password | string | `"Google123"` | no |
| sap\_hana\_sidadm\_uid | SAP hana sid adm password | string | `"900"` | no |
| sap\_hana\_system\_password | SAP hana system password | string | `"Google123"` | no |
| service\_account | Service to run terraform | string | n/a | yes |
| subnetwork | Compute Engine instance name | string | `""` | no |
| zone | Compute Engine instance deployment zone | string | `"us-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | Name of instance |
| sap\_hana\_sid | SAP Hana SID user |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


## Integration Tests

### Additional Service Account Permissions
If you need to run integration tests, the service for deploying resources needs the follwoing additional permissions:

- roles/storage.admin

 You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.admin`

### Running integration tests

Refer to the [contributing guidelines' Integration Testing Section](../../CONTRIBUTING.md#integration-test) for running integration tests for this example.