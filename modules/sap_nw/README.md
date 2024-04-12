# Terraform for SAP NW for Google Cloud
This template follows the documented steps https://cloud.google.com/solutions/sap/docs/netweaver-deployment-guide-linux and deploys GCP and Pacemaker resources up to the installation of SAP's central services.

## Set up Terraform

Install Terraform on the machine you would like to use to deploy from by following https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started#install-terraform

## How to deploy

1. Download .tf file into an empty directory
`curl https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_nw/terraform/sap_nw.tf -o sap_nw.tf`

2. Fill in mandatory variables and if the desired optional variable in the .tf file.

3. Deploy
  1. Run `terraform init` (only needed once)
  2. Run `terraform plan` to see what is going to be deployed. Verify if names, zones, sizes, etc. are as desired.
  3. Run `terrafom apply` to deploy the resources
  4. Run `terrafom destroy` to remove the resources

4. Continue installation of SAP software and setup of remaining cluster resources as per documentation at https://cloud.google.com/solutions/sap/docs/netweaver-deployment-guide-linux

## Additional information

For additional information see https://www.terraform.io/docs/index.html and https://cloud.google.com/docs/terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| can\_ip\_forward | Whether sending and receiving of packets with non-matching source or destination IPs is allowed. | `bool` | `true` | no |
| instance\_name | Hostname of the GCE instance. | `string` | n/a | yes |
| linux\_image | Linux image name to use. | `string` | n/a | yes |
| linux\_image\_project | The project which the Linux image belongs to. | `string` | n/a | yes |
| machine\_type | Machine type for the instances. | `string` | n/a | yes |
| network\_tags | OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes. | `list(string)` | `[]` | no |
| post\_deployment\_script | OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment. | `string` | `""` | no |
| primary\_startup\_url | Startup script to be executed when the VM boots, should not be overridden. | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform/sap_nw/startup.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform"` | no |
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |
| public\_ip | OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail. | `bool` | `true` | no |
| reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| sap\_deployment\_debug | OPTIONAL - If this value is set to true, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging. | `bool` | `false` | no |
| sap\_mnt\_size | Size of /sapmnt in GB | `number` | `8` | no |
| service\_account | OPTIONAL - Ability to define a custom service account instead of using the default project service account. | `string` | `""` | no |
| subnetwork | The sub network to deploy the instance in. | `string` | n/a | yes |
| swap\_size | Size in GB of swap volume | `number` | `8` | no |
| usr\_sap\_size | Size of /usr/sap in GB | `number` | `8` | no |
| zone | Zone where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_nw\_self\_link | SAP NW self-link for instance created |

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
