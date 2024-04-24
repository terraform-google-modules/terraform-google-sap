# Terraform for SAP HANA HA for Google Cloud

This template follows the documented steps
https://cloud.google.com/solutions/sap/docs/certifications-sap-hana and deploys
GCP and Pacemaker resources up to the installation of SAP's central services.

## Set up Terraform

Install Terraform on the machine you would like to use to deploy from by
following
https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started#install-terraform

## How to deploy

1.  Download .tf file into an empty directory `curl
    https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_hana_ha/terraform/sap_hana_ha.tf
    -o sap_hana_ha.tf`

2.  Fill in mandatory variables and if the desired optional variable in the .tf
    file.

3.  Deploy

    1.  Run `terraform init` (only needed once)
    2.  Run `terraform plan` to see what is going to be deployed. Verify if
        names, zones, sizes, etc. are as desired.
    3.  Run `terrafom apply` to deploy the resources
    4.  Run `terrafom destroy` to remove the resources

4.  Continue installation of SAP software and setup of remaining cluster
    resources as per documentation at
    https://cloud.google.com/solutions/sap/docs/sap-hana-ha-tf-deployment

## Additional information

For additional information see https://www.terraform.io/docs/index.html and
https://cloud.google.com/docs/terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_disk\_iops\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the backup disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| backup\_disk\_throughput\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the backup disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| backup\_disk\_type | Optional - The default is hyperdisk-balanced for native bare metal machines and pd-balanced otherwise, only used if a backup disk is needed. | `string` | `""` | no |
| can\_ip\_forward | Whether sending and receiving of packets with non-matching source or destination IPs is allowed. | `bool` | `true` | no |
| data\_disk\_iops\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the data disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| data\_disk\_size\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the data disk(s), that is based off of the machine\_type. | `number` | `null` | no |
| data\_disk\_throughput\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the data disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| data\_disk\_type\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default\_disk\_type' for the data disk. | `string` | `""` | no |
| disk\_type | Optional - The default disk type to use for disk(s) containing log and data volumes. The default is hyperdisk-extreme for native bare metal machines and pd-ssd otherwise. Not all disk are supported on all machine types - see https://cloud.google.com/compute/docs/disks/ for details. | `string` | `""` | no |
| enable\_fast\_restart | Optional - The default is true. If set enables HANA Fast Restart. | `bool` | `true` | no |
| hyperdisk\_balanced\_iops\_default | Optional - default is 3000. Number of IOPS that is set for each disk of type Hyperdisk-balanced (except for boot/usrsap/shared disks). | `number` | `3000` | no |
| hyperdisk\_balanced\_throughput\_default | Optional - default is 750. Throughput in MB/s that is set for each disk of type Hyperdisk-balanced (except for boot/usrsap/shared disks). | `number` | `750` | no |
| include\_backup\_disk | Optional - The default is true. If set creates a disk for backups. | `bool` | `true` | no |
| is\_work\_load\_management\_deployment | If set the necessary tags and labels will be added to resoucres to support WLM. | `bool` | `false` | no |
| linux\_image | Linux image name to use. | `string` | n/a | yes |
| linux\_image\_project | The project which the Linux image belongs to. | `string` | n/a | yes |
| loadbalancer\_name | OPTIONAL - Name of the load balancer that will be created. If left blank with use\_ilb\_vip set to true, then will use lb-SID as default | `string` | `""` | no |
| log\_disk\_iops\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the log disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| log\_disk\_size\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the log disk(s), that is based off of the machine\_type. | `number` | `null` | no |
| log\_disk\_throughput\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the log disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| log\_disk\_type\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default\_disk\_type' for the log disk. | `string` | `""` | no |
| machine\_type | Machine type for the instances. | `string` | n/a | yes |
| majority\_maker\_instance\_name | Optional - Name to use for the Majority Maker instance. Must be provided if scaleout\_nodes > 0. | `string` | `""` | no |
| majority\_maker\_machine\_type | Optional - The machine type to use for the Majority Maker instance. Must be provided if scaleout\_nodes > 0. | `string` | `""` | no |
| majority\_maker\_startup\_url | DO NOT USE | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform/sap_hana_ha/startup_majority_maker.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform"` | no |
| majority\_maker\_zone | Optional - The zone in which the Majority Maker instance will be deployed. Must be provided if scaleout\_nodes > 0. It is recommended for this to be different from the zones the primary and secondary instance are deployed in. | `string` | `""` | no |
| network | Network in which the ILB resides including resources like firewall rules. | `string` | n/a | yes |
| network\_tags | OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes. | `list(string)` | `[]` | no |
| nic\_type | Optional - This value determines the type of NIC to use, valid options are GVNIC and VIRTIO\_NET. If choosing GVNIC make sure that it is supported by your OS choice here https://cloud.google.com/compute/docs/images/os-details#networking. | `string` | `""` | no |
| post\_deployment\_script | OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment. | `string` | `""` | no |
| primary\_instance\_group\_name | OPTIONAL - Unmanaged instance group to be created for the primary node. If blank, will use ig-VM\_NAME | `string` | `""` | no |
| primary\_instance\_name | Hostname of the primary GCE instance. | `string` | n/a | yes |
| primary\_reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| primary\_startup\_url | Startup script to be executed when the VM boots, should not be overridden. | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform/sap_hana_ha/startup.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform"` | no |
| primary\_static\_ip | Optional - Defines an internal static IP for the primary VM. | `string` | `""` | no |
| primary\_worker\_static\_ips | Optional - Defines internal static IP addresses for the primary worker nodes. | `list(string)` | `[]` | no |
| primary\_zone | Zone where the primary instances will be created. | `string` | n/a | yes |
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |
| public\_ip | OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail. | `bool` | `true` | no |
| sap\_deployment\_debug | OPTIONAL - If this value is set to true, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging. | `bool` | `false` | no |
| sap\_hana\_backup\_size | Size in GB of the /hanabackup volume. If this is not set or set to zero, the GCE instance will be provisioned with a hana backup volume of 2 times the total memory. | `number` | `0` | no |
| sap\_hana\_deployment\_bucket | The Cloud Storage path that contains the SAP HANA media, do not include gs://. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. | `string` | `""` | no |
| sap\_hana\_instance\_number | The SAP instance number. If this is not defined, the GCE instance will be provisioned without SAP HANA installed. | `number` | `0` | no |
| sap\_hana\_sapsys\_gid | The Linux GID of the SAPSYS group. By default this is set to 79 | `number` | `79` | no |
| sap\_hana\_scaleout\_nodes | Optional - Specify to add scaleout nodes to both HA instances. | `number` | `0` | no |
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
| secondary\_startup\_url | DO NOT USE | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform/sap_hana_ha/startup_secondary.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform"` | no |
| secondary\_static\_ip | Optional - Defines an internal static IP for the secondary VM. | `string` | `""` | no |
| secondary\_worker\_static\_ips | Optional - Defines internal static IP addresses for the secondary worker nodes. | `list(string)` | `[]` | no |
| secondary\_zone | Zone where the secondary instances will be created. | `string` | n/a | yes |
| service\_account | OPTIONAL - Ability to define a custom service account instead of using the default project service account. | `string` | `""` | no |
| shared\_disk\_iops\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the shared disk will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| shared\_disk\_size\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the shared disk, that is based off of the machine\_type. | `number` | `null` | no |
| shared\_disk\_throughput\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the shared disk will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| shared\_disk\_type\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default\_disk\_type' for the shared disk. | `string` | `""` | no |
| subnetwork | The sub network to deploy the instance in. | `string` | n/a | yes |
| unified\_disk\_iops\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the primary's unified disk will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| unified\_disk\_size\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the primary disk(s), that is based off of the machine\_type. | `number` | `null` | no |
| unified\_disk\_throughput\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the primary's unified disk will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| use\_single\_shared\_data\_log\_disk | Optional - By default three separate disk for data, logs, and shared will be made. If set to true, one disk will be used instead. | `bool` | `false` | no |
| usrsap\_disk\_iops\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the number of IOPS that the /usr/sap disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| usrsap\_disk\_size\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Overrides the default size for the /usr/sap disk(s), that is based off of the machine\_type. | `number` | `null` | no |
| usrsap\_disk\_throughput\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Directly sets the throughput in MB/s that the /usr/sap disk(s) will use. Has no effect if not using a disk type that supports it. | `number` | `null` | no |
| usrsap\_disk\_type\_override | Warning, do not use unless instructed or aware of the implications of using this setting. Override the 'default\_disk\_type' for the /usr/sap disk. | `string` | `""` | no |
| wlm\_deployment\_name | Deployment name to be used for integrating into Work Load Management. | `string` | `""` | no |
| worker\_startup\_url | Startup script to be executed when the worker VM boots, should not be overridden. | `string` | `"curl -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform/sap_hana_ha/startup_worker.sh | bash -s https://www.googleapis.com/storage/v1/core-connect-dm-templates/202404101403/terraform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| sap\_hana\_ha\_firewall\_link | Link to the optional fire wall |
| sap\_hana\_ha\_loadbalander\_link | Link to the optional load balancer |
| sap\_hana\_ha\_primary\_instance\_self\_link | Self-link for the primary SAP HANA HA instance created. |
| sap\_hana\_ha\_primary\_worker\_self\_links | Self-link for the worker nodes in the primary SAP HANA HA instance. |
| sap\_hana\_ha\_secondary\_instance\_self\_link | Self-link for the secondary SAP HANA HA instance created. |
| sap\_hana\_ha\_secondary\_worker\_self\_links | Self-link for the worker nodes in the secondary SAP HANA HA instance. |

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
