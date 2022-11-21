# terraform-google-sap for SAP HANA HA

This module is meant to create SAP HANA HA instance(s) for Google Cloud

The resources/services/activations/deletions that this module will create/trigger are:

- A set of compute engine instances, primary and secondary (if specified)
- A set of compute disks
- IP addresses for the instances to use
- Primary and secondary (if specified) GCE instance groups

## Usage

Basic usage of this module is as follows:

```hcl
module "sap_hana_ha" {
  source  = "terraform-google-modules/sap/google//modules/sap_hana_ha"
  version = "~> 1.0"

  project_id              = "PROJECT_ID"          # example: my-project-x
  machine_type            = "MACHINE_TYPE"        # example: n1-highmem-32
  network                 = "NETWORK"             # example: default
  subnetwork              = "SUBNETWORK"          # example: default
  linux_image             = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project     = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud
  primary_instance_name   = "PRIMARY_NAME"        # example: hana-ha-primary
  primary_zone            = "PRIMARY_ZONE"        # example: us-east1-b, must be in the same region as secondary_zone
  secondary_instance_name = "SECONDARY_NAME"      # example: hana-ha-secondary
  secondary_zone          = "SECONDARY_ZONE"      # example: us-east1-c, must be in the same region as primary_zone
}
```

Functional example is included in the
[examples](./examples/sap_hana_ha_simple) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| can\_ip\_forward | Whether sending and receiving of packets with non-matching source or destination IPs is allowed. | `bool` | `true` | no |
| is\_work\_load\_management\_deployment | If set the necessary tags and labels will be added to resoucres to support WLM. | `bool` | `false` | no |
| linux\_image | Linux image name to use. | `string` | n/a | yes |
| linux\_image\_project | The project which the Linux image belongs to. | `string` | n/a | yes |
| loadbalancer\_name | OPTIONAL - Name of the load balancer that will be created. If left blank with use\_ilb\_vip set to true, then will use lb-SID as default | `string` | `""` | no |
| machine\_type | Machine type for the instances. | `string` | n/a | yes |
| network | Network in which the ILB resides including resources like firewall rules. | `string` | n/a | yes |
| network\_tags | OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes. | `list(string)` | `[]` | no |
| post\_deployment\_script | OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment. | `string` | `""` | no |
| primary\_instance\_group\_name | OPTIONAL - Unmanaged instance group to be created for the primary node. If blank, will use ig-VM\_NAME | `string` | `""` | no |
| primary\_instance\_name | Hostname of the primary GCE instance. | `string` | n/a | yes |
| primary\_reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| primary\_startup\_url | Startup script to be executed when the VM boots, should not be overridden. | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform/sap_hana_ha/startup.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform"` | no |
| primary\_zone | Zone where the primary instances will be created. | `string` | n/a | yes |
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |
| public\_ip | OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail. | `bool` | `true` | no |
| sap\_deployment\_debug | OPTIONAL - If this value is set to true, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging. | `bool` | `false` | no |
| sap\_hana\_backup\_size | Size in GB of the /hanabackup volume. If this is not set or set to zero, the GCE instance will be provisioned with a hana backup volume of 2 times the total memory. | `number` | `0` | no |
| sap\_hana\_deployment\_bucket | The GCS bucket containing the SAP HANA media. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. | `string` | `""` | no |
| sap\_hana\_instance\_number | The SAP instance number. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. | `number` | `0` | no |
| sap\_hana\_sapsys\_gid | The Linux GID of the SAPSYS group. By default this is set to 79 | `number` | `79` | no |
| sap\_hana\_sid | The SAP HANA SID. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. SID must adhere to SAP standard (Three letters or numbers and start with a letter) | `string` | `""` | no |
| sap\_hana\_sidadm\_password | The linux sidadm login password. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. Minimum requirement is 8 characters. | `string` | `""` | no |
| sap\_hana\_sidadm\_password\_secret | The secret key used to retrieve the linux sidadm login from Secret Manager (https://cloud.google.com/secret-manager). The Secret Manager password will overwrite the clear text password from sap\_hana\_sidadm\_password if both are set. | `string` | `""` | no |
| sap\_hana\_sidadm\_uid | The Linux UID of the <SID>adm user. By default this is set to 900 to avoid conflicting with other OS users. | `number` | `900` | no |
| sap\_hana\_system\_password | The SAP HANA SYSTEM password. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. Minimum requirement is 8 characters with at least 1 number. | `string` | `""` | no |
| sap\_hana\_system\_password\_secret | The secret key used to retrieve the SAP HANA SYSTEM login from Secret Manager (https://cloud.google.com/secret-manager). The Secret Manager password will overwrite the clear text password from sap\_hana\_system\_password if both are set. | `string` | `""` | no |
| sap\_vip | OPTIONAL - The virtual IP address of the alias/route pointing towards the active SAP HANA instance. For a route based solution this IP must sit outside of any defined networks. | `string` | `""` | no |
| secondary\_instance\_group\_name | OPTIONAL - Unmanaged instance group to be created for the secondary node. If blank, will use ig-VM\_NAME | `string` | `""` | no |
| secondary\_instance\_name | Hostname of the secondary GCE instance. | `string` | n/a | yes |
| secondary\_reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| secondary\_startup\_url | DO NOT USE | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform/sap_hana_ha/startup_secondary.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform"` | no |
| secondary\_zone | Zone where the secondary instances will be created. | `string` | n/a | yes |
| service\_account | OPTIONAL - Ability to define a custom service account instead of using the default project service account. | `string` | `""` | no |
| subnetwork | The sub network to deploy the instance in. | `string` | n/a | yes |
| wlm\_deployment\_name | Deployment name to be used for integrating into Work Load Management. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| sap\_hana\_ha\_firewall\_link | Link to the optional fire wall |
| sap\_hana\_ha\_loadbalander\_link | Link to the optional load balancer |
| sap\_hana\_ha\_primary\_instance\_self\_link | Self-link for the primary SAP HANA HA instance created. |
| sap\_hana\_ha\_secondary\_instance\_self\_link | Self-link for the secondary SAP HANA HA instance created. |

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
