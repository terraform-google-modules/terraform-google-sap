# SAP NW HA example

This example illustrates how to use the latest release of the terraform module for SAP on Google Cloud for provisioning SAP NetWeaver High-availability.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_nw\_ers\_worker\_self\_links | SAP NW ERS self-links for the instance created |
| sap\_nw\_scs\_primary\_self\_link | SAP NW SCS self-link for the instance created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
