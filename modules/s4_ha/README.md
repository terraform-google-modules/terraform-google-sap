# Terraform for SAP S/4HANA HA for Google Cloud

This template implements the GCP S4 High Availability reference architecture
https://cloud.google.com/solutions/sap/docs/architectures/sap-s4hana-on-gcp.

## Usage

Basic usage of this module is as follows:

```hcl
module "s4_ha" {
  source  = "terraform-google-modules/sap/google//modules/s4_ha"
  version = "~> 1.2"

  gcp_project_id      = "PROJECT_ID"       # example: my-project-x
  deployment_name     = "DEPLOYMENT_NAME"  # example: my-deployment
  media_bucket_name   = "GCS_BUCKET"       # example: my-bucket
  filestore_location  = "ZONE/REGION"      # example: us-east1
  region_name         = "REGION"           # example: us-east1
  zone1_name          = "ZONE"             # example: us-east1-b
  zone2_name          = "ZONE"             # example: us-east1-c
}
```

Functional example is included in the
[examples](../../examples/sap_hana_simple) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_stopping\_for\_update | allow\_stopping\_for\_update | `bool` | `true` | no |
| ansible\_sa\_email | ansible\_sa\_email | `string` | `""` | no |
| app\_disk\_export\_interfaces\_size | app\_disk\_export\_interfaces\_size | `number` | `128` | no |
| app\_disk\_usr\_sap\_size | app\_disk\_usr\_sap\_size | `number` | `128` | no |
| app\_machine\_type | app\_machine\_type | `string` | `"n1-highem-32"` | no |
| app\_sa\_email | app\_sa\_email | `string` | `""` | no |
| app\_sid | app\_sid | `string` | `"ED1"` | no |
| app\_vms\_multiplier | Multiplies app VMs. E.g. if there is 2 VMs then with value 3 each VM will be multiplied by 3 (so there will be 6 total VMs) | `string` | `1` | no |
| application\_secret\_name | application\_secret\_name | `string` | `"default"` | no |
| ascs\_disk\_usr\_sap\_size | ascs\_disk\_usr\_sap\_size | `number` | `128` | no |
| ascs\_ilb\_healthcheck\_port | ascs\_ilb\_healthcheck\_port | `number` | `60001` | no |
| ascs\_machine\_type | ascs\_machine\_type | `string` | `"n1-standard-8"` | no |
| ascs\_sa\_email | ascs\_sa\_email | `string` | `""` | no |
| ascs\_vm\_names | ascs\_vm\_names | `list(any)` | `[]` | no |
| configuration\_bucket\_name | configuration\_bucket\_name | `string` | `""` | no |
| create\_comms\_firewall | create\_comms\_firewall | `bool` | `true` | no |
| data\_stripe\_size | data\_stripe\_size | `string` | `"256k"` | no |
| db\_disk\_backup\_size | db\_disk\_backup\_size | `number` | `128` | no |
| db\_disk\_hana\_data\_size | db\_disk\_hana\_data\_size | `number` | `249` | no |
| db\_disk\_hana\_log\_size | db\_disk\_hana\_log\_size | `number` | `104` | no |
| db\_disk\_hana\_shared\_size | db\_disk\_hana\_shared\_size | `number` | `208` | no |
| db\_disk\_usr\_sap\_size | db\_disk\_usr\_sap\_size | `number` | `32` | no |
| db\_ilb\_healthcheck\_port | db\_ilb\_healthcheck\_port | `number` | `60000` | no |
| db\_machine\_type | db\_machine\_type | `string` | `"n1-highmem-32"` | no |
| db\_sa\_email | db\_sa\_email | `string` | `""` | no |
| db\_sid | db\_sid | `string` | `"HD1"` | no |
| db\_vm\_names | db\_vm\_names | `list(any)` | `[]` | no |
| deployment\_name | deployment\_name | `string` | n/a | yes |
| disk\_type | disk\_type | `string` | `"pd-balanced"` | no |
| dns\_zone\_name\_suffix | dns\_zone\_name\_suffix | `string` | `"gcp.sapcloud.goog."` | no |
| ers\_ilb\_healthcheck\_port | ers\_ilb\_healthcheck\_port | `number` | `60002` | no |
| existing\_dns\_zone\_name | existing\_dns\_zone\_name | `string` | `""` | no |
| filestore\_gb | filestore\_gb | `number` | `1024` | no |
| filestore\_location | filestore\_location | `string` | n/a | yes |
| filestore\_tier | filestore\_tier | `string` | `"ENTERPRISE"` | no |
| gcp\_project\_id | gcp\_project\_id | `string` | n/a | yes |
| hana\_secret\_name | hana\_secret\_name | `string` | `"default"` | no |
| is\_test | is\_test | `string` | `"false"` | no |
| log\_stripe\_size | log\_stripe\_size | `string` | `"64k"` | no |
| media\_bucket\_name | media\_bucket\_name | `string` | n/a | yes |
| network\_project | network\_project | `string` | `""` | no |
| number\_data\_disks | Optional - default is 1. Number of disks to use for data volume striping (if larger than 1). | `number` | `1` | no |
| number\_log\_disks | Optional - default is 1. Number of disks to use for log volume striping (if larger than 1). | `number` | `1` | no |
| package\_location | package\_location | `string` | `"gs://cloudsapdeploy/deployments/latest"` | no |
| primary\_startup\_url | primary\_startup\_url | `string` | `"gs://cloudsapdeploy/deployments/latest/startup/ansible_runner_startup.sh"` | no |
| public\_ansible\_runner\_ip | public\_ansible\_runner\_ip | `bool` | `true` | no |
| public\_ip | public\_ip | `bool` | `false` | no |
| region\_name | region\_name | `string` | n/a | yes |
| sap\_boot\_disk\_image | sap\_boot\_disk\_image | `string` | `"projects/rhel-sap-cloud/global/images/rhel-8-4-sap-v20220719"` | no |
| sap\_boot\_disk\_image\_app | sap\_boot\_disk\_image\_app | `string` | `""` | no |
| sap\_boot\_disk\_image\_ascs | sap\_boot\_disk\_image\_ascs | `string` | `""` | no |
| sap\_boot\_disk\_image\_db | sap\_boot\_disk\_image\_db | `string` | `""` | no |
| sap\_instance\_id\_app | sap\_instance\_id\_app | `string` | `"10"` | no |
| sap\_instance\_id\_ascs | sap\_instance\_id\_ascs | `string` | `"11"` | no |
| sap\_instance\_id\_db | sap\_instance\_id\_db | `string` | `"00"` | no |
| sap\_instance\_id\_ers | sap\_instance\_id\_ers | `string` | `"12"` | no |
| sap\_version | sap\_version | `string` | `"2021"` | no |
| subnet\_name | subnet\_name | `string` | `"default"` | no |
| virtualize\_disks | virtualize\_disks | `bool` | `true` | no |
| vm\_prefix | vm\_prefix | `string` | `"sapha"` | no |
| vpc\_name | vpc\_name | `string` | `"default"` | no |
| zone1\_name | zone1\_name | `string` | n/a | yes |
| zone2\_name | zone2\_name | `string` | n/a | yes |

## Outputs

No outputs.

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
