# SAP HANA example

This example illustrates how to use the latest release of the terraform module for SAP on Google Cloud for provisioning SAP HANA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_hana\_primary\_self\_link | SAP HANA self-link for the primary instance created |
| sap\_hana\_worker\_self\_links | SAP HANA self-links for the secondary instances created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
