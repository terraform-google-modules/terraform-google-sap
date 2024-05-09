# SAP HANA example

This example illustrates how to use the latest release of the terraform module for SAP on Google Cloud for provisioning SAP HANA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deployment\_name | deployment\_name | `string` | `"my_s4"` | no |
| filestore\_location | filestore\_location | `string` | `"us-east1-b"` | no |
| gcp\_project\_id | Project id where the instances will be created | `string` | n/a | yes |
| media\_bucket\_name | Project bucket with installation media available. This must be handled for HANA to be installed | `string` | `"custom-bucket"` | no |
| region\_name | region\_name | `string` | `"us-east1"` | no |
| zone1\_name | zone1\_name | `string` | `"us-east1-c"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
