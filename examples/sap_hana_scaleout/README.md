# SAP HANA Scaleout example

This example illustrates how to use the latest release of the terraform module for SAP on Google Cloud
for provisioning SAP HANA with scaleout

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| hana\_scaleout\_standby\_self\_links | List of self-links for the hana scaleout standby workers created |
| hana\_scaleout\_worker\_self\_links | List of self-links for the hana scaleout workers created |
| sap\_hana\_primary\_self\_link | Self-link for the primary SAP HANA Scalout instance created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
