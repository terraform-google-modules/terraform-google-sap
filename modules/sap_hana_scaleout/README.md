# terraform-google-sap for SAP HANA Scaleout

This template follows the documented steps
https://cloud.google.com/solutions/sap/docs/sap-hana-ha-scaleout-tf-deployment-guide and deploys an SAP HANA scale-out system that includes the SAP HANA host auto-failover fault-recovery solution.

## Usage

Basic usage of this module is as follows:

```hcl
module "hana_scaleout" {
  source  = "terraform-google-modules/sap/google//modules/sap_hana_scaleout"
  version = "~> 1.0"

  project_id          = "PROJECT_ID"          # example: my-project-x
  zone                = "ZONE"                # example: us-east1-b
  machine_type        = "MACHINE_TYPE"        # example: n1-highmem-32
  subnetwork          = "SUBNETWORK"          # example: default
  linux_image         = "LINUX_IMAGE"         # example: rhel-8-4-sap-ha
  linux_image_project = "LINUX_IMAGE_PROJECT" # example: rhel-sap-cloud
  instance_name       = "VM_NAME"             # example: hana-instance
  sap_hana_sid        = "SID"                 # example: ABC, Must conform to [a-zA-Z][a-zA-Z0-9]{2}
  sap_hana_shared_nfs = "HANA_SHARED_NFS"     # example: 10.10.10.10:/shared
  sap_hana_backup_nfs = "HANA_BACKUP_NFS"     # example: 10.10.10.10:/backup
}
```

Functional example is included in the
[examples](./examples/sap_hana_scaleout) directory.

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
| primary\_startup\_url | Startup script to be executed when the VM boots, should not be overridden. | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform/sap_hana_scaleout/startup.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform"` | no |
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |
| public\_ip | OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail. | `bool` | `true` | no |
| reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| sap\_deployment\_debug | OPTIONAL - If this value is set to true, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging. | `bool` | `false` | no |
| sap\_hana\_backup\_nfs | Google Filestore share for /hanabackup | `string` | n/a | yes |
| sap\_hana\_deployment\_bucket | The GCS bucket containing the SAP HANA media. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. | `string` | `""` | no |
| sap\_hana\_instance\_number | The SAP instance number. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. | `number` | `0` | no |
| sap\_hana\_sapsys\_gid | The Linux GID of the SAPSYS group. By default this is set to 79 | `number` | `79` | no |
| sap\_hana\_shared\_nfs | Google Filestore share for /hana/shared | `string` | n/a | yes |
| sap\_hana\_sid | The SAP HANA SID. SID must adhere to SAP standard (Three letters or numbers and start with a letter) | `string` | n/a | yes |
| sap\_hana\_sidadm\_password | The linux sidadm login password. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. Minimum requirement is 8 characters. | `string` | `""` | no |
| sap\_hana\_sidadm\_password\_secret | The secret key used to retrieve the linux sidadm login from Secret Manager (https://cloud.google.com/secret-manager). The Secret Manager password will overwrite the clear text password from sap\_hana\_sidadm\_password if both are set. | `string` | `""` | no |
| sap\_hana\_sidadm\_uid | The Linux UID of the <SID>adm user. By default this is set to 900 to avoid conflicting with other OS users. | `number` | `900` | no |
| sap\_hana\_standby\_nodes | Number of standby nodes to create. | `number` | `1` | no |
| sap\_hana\_system\_password | The SAP HANA SYSTEM password. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. Minimum requirement is 8 characters with at least 1 number. | `string` | `""` | no |
| sap\_hana\_system\_password\_secret | The secret key used to retrieve the SAP HANA SYSTEM login from Secret Manager (https://cloud.google.com/secret-manager). The Secret Manager password will overwrite the clear text password from sap\_hana\_system\_password if both are set. | `string` | `""` | no |
| sap\_hana\_worker\_nodes | Number of worker nodes to create.<br>This is in addition to the primary node. | `number` | `1` | no |
| secondary\_startup\_url | DO NOT USE | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform/sap_hana_scaleout/startup_secondary.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202211212015/terraform"` | no |
| service\_account | OPTIONAL - Ability to define a custom service account instead of using the default project service account. | `string` | `""` | no |
| subnetwork | The sub network to deploy the instance in. | `string` | n/a | yes |
| zone | Zone where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| hana\_scaleout\_standby\_self\_links | List of self-links for the hana scaleout standbys created |
| hana\_scaleout\_worker\_self\_links | List of self-links for the hana scaleout workers created |
| sap\_hana\_primary\_self\_link | Self-link for the primary SAP HANA Scalout instance created. |

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
