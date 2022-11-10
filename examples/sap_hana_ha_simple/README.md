# SAP HANA HA example

This example illustrates how to use the latest release of the terraform module for SAP on Google Cloud
for provisioning SAP HANA with HA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_hana\_ha\_firewall\_link | Link to the optional fire wall |
| sap\_hana\_ha\_loadbalander\_link | Link to the optional load balancer |
| sap\_hana\_ha\_primary\_instance\_self\_link | Self-link for the primary SAP HANA HA instance created. |
| sap\_hana\_ha\_secondary\_instance\_self\_link | Self-link for the secondary SAP HANA HA instance created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
