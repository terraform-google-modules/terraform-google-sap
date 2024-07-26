# Terraform for SAP NW HA for Google Cloud
This template follows the documented steps https://cloud.google.com/solutions/sap/docs/netweaver-ha-config-sles and https://cloud.google.com/solutions/sap/docs/netweaver-ha-config-rhel and deploys GCP and Pacemaker resources up to the installation of SAP's central services.

## Set up Terraform

Install Terraform on the machine you would like to use to deploy from by following https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started#install-terraform

## How to deploy

1. Download .tf file into an empty directory
`curl https://storage.googleapis.com/cloudsapdeploy/deploymentmanager/latest/dm-templates/sap_nw_ha/terraform/sap_nw_ha.tf -o sap_nw_ha.tf`

2. Fill in mandatory variables and if the desired optional variable in the .tf file.

3. Deploy
  1. Run `terraform init` (only needed once)
  2. Run `terraform plan` to see what is going to be deployed. Verify if names, zones, sizes, etc. are as desired.
  3. Run `terrafom apply` to deploy the resources
  4. Run `terrafom destroy` to remove the resources

4. Continue installation of SAP software and setup of remaining cluster resources as per documentation at https://cloud.google.com/solutions/sap/docs/netweaver-ha-config-sles or https://cloud.google.com/solutions/sap/docs/netweaver-ha-config-rhel

## Additional information

For additional information see https://www.terraform.io/docs/index.html and https://cloud.google.com/docs/terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| can\_ip\_forward | Whether sending and receiving of packets with non-matching source or destination IPs is allowed. | `bool` | `true` | no |
| ers\_backend\_svc\_name | Name of ERS backend service | `string` | `""` | no |
| ers\_forw\_rule\_name | Name of ERS forwarding rule | `string` | `""` | no |
| ers\_hc\_name | Name of ERS health check | `string` | `""` | no |
| ers\_hc\_port | Port of ERS health check | `string` | `""` | no |
| ers\_inst\_group\_name | Name of ERS instance group | `string` | `""` | no |
| ers\_vip\_address | Address of ERS virtual IP | `string` | `""` | no |
| ers\_vip\_name | Name of ERS virtual IP | `string` | `""` | no |
| hc\_firewall\_rule\_name | Name of firewall rule for the health check | `string` | `""` | no |
| hc\_network\_tag | Network tag for the health check firewall rule | `list(string)` | `[]` | no |
| linux\_image | Linux image name | `string` | n/a | yes |
| linux\_image\_project | Linux image project | `string` | n/a | yes |
| machine\_type | Machine type for the instances | `string` | n/a | yes |
| network | Network for the instances | `string` | n/a | yes |
| network\_tags | Network tags to apply to the instances | `list(string)` | `[]` | no |
| nfs\_path | NFS path for shared file system, e.g. 10.163.58.114:/ssd | `string` | n/a | yes |
| pacemaker\_cluster\_name | Name of Pacemaker cluster. | `string` | `""` | no |
| post\_deployment\_script | Specifies the location of a script to run after the deployment is complete.<br>The script should be hosted on a web server or in a GCS bucket. The URL should<br>begin with http:// https:// or gs://. Note that this script will be executed<br>on all VM's that the template creates. If you only want to run it on the master<br>instance you will need to add a check at the top of your script. | `string` | `""` | no |
| primary\_reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : "Intel Skylake"<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| primary\_startup\_url | DO NOT USE | `string` | `"curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_nw_ha/nw_ha_startup_scs.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"` | no |
| project\_id | Project id where the instances will be created | `string` | n/a | yes |
| public\_ip | Create an ephemeral public ip for the instances | `bool` | `false` | no |
| sap\_deployment\_debug | Debug log level for deployment | `bool` | `false` | no |
| sap\_ers\_instance\_number | ERS instance number | `string` | `"10"` | no |
| sap\_mnt\_size | Size of /sapmnt in GB | `number` | `8` | no |
| sap\_nw\_abap | Is this a Netweaver ABAP installation. Set 'false' for NW Java. Dual stack is not supported by this script. | `bool` | `true` | no |
| sap\_primary\_instance | Name of first instance (initial SCS location) | `string` | n/a | yes |
| sap\_primary\_zone | Zone where the first instance will be created | `string` | n/a | yes |
| sap\_scs\_instance\_number | SCS instance number | `string` | `"00"` | no |
| sap\_secondary\_instance | Name of second instance (initial ERS location) | `string` | n/a | yes |
| sap\_secondary\_zone | Zone where the second instance will be created | `string` | n/a | yes |
| sap\_sid | SAP System ID | `string` | n/a | yes |
| scs\_backend\_svc\_name | Name of SCS backend service | `string` | `""` | no |
| scs\_forw\_rule\_name | Name of SCS forwarding rule | `string` | `""` | no |
| scs\_hc\_name | Name of SCS health check | `string` | `""` | no |
| scs\_hc\_port | Port of SCS health check | `string` | `""` | no |
| scs\_inst\_group\_name | Name of SCS instance group | `string` | `""` | no |
| scs\_vip\_address | Address of SCS virtual IP | `string` | `""` | no |
| scs\_vip\_name | Name of SCS virtual IP | `string` | `""` | no |
| secondary\_reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : "Intel Skylake"<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| secondary\_startup\_url | DO NOT USE | `string` | `"curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_nw_ha/nw_ha_startup_ers.sh | bash -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"` | no |
| service\_account | Service account that will be used as the service account on the created instance.<br>Leave this blank to use the project default service account | `string` | `""` | no |
| subnetwork | Subnetwork for the instances | `string` | n/a | yes |
| swap\_size | Size in GB of swap volume | `number` | `8` | no |
| usr\_sap\_size | Size of /usr/sap in GB | `number` | `8` | no |

## Outputs

| Name | Description |
|------|-------------|
| ers\_instance | ERS instance |
| nw\_forwarding\_rules | Forwarding rules |
| nw\_hc | Health Checks |
| nw\_hc\_firewall | Firewall rule for the Health Checks |
| nw\_instance\_groups | NW Instance Groups |
| nw\_regional\_backend\_services | Backend Services |
| nw\_vips | NW virtual IPs |
| scs\_instance | SCS instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v4.0

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
