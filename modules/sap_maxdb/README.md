TODO add README info
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| can\_ip\_forward | Whether sending and receiving of packets with non-matching source or destination IPs is allowed. | `bool` | `true` | no |
| custom\_metadata | Optional - default is empty. Custom metadata to be added to the VM. | `map(string)` | `{}` | no |
| instance\_name | Hostname of the GCE instance | `string` | n/a | yes |
| linux\_image | Linux image name to use. family/sles-12-sp2-sap or family/sles-12-sp2-sap will use the latest SLES 12 SP2 or SP3 image | `string` | n/a | yes |
| linux\_image\_project | The project which the Linux image belongs to | `string` | n/a | yes |
| machine\_type | Machine type to deploy | `string` | n/a | yes |
| maxdb\_backup\_size | OPTIONAL - Size of the /maxdbbackup volume. If set to 0, no disk will be created | `number` | `0` | no |
| maxdb\_data\_size | Size of /sapdb/[DBSID]/sapdata - Which holds the database data files | `number` | `30` | no |
| maxdb\_data\_ssd | SSD toggle for the data drive. If set to true, the data disk will be SSD | `bool` | `true` | no |
| maxdb\_log\_size | Size of /sapdb/[DBSID]/saplog - Which holds the database transaction logs | `number` | `8` | no |
| maxdb\_log\_ssd | SSD toggle for the log drive. If set to true, the log disk will be SSD | `bool` | `true` | no |
| maxdb\_root\_size | Size of /sapdb - the root directory of the database instance | `number` | `8` | no |
| maxdb\_sid | The database instance/SID name | `string` | n/a | yes |
| network\_tags | OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes | `list(string)` | `[]` | no |
| post\_deployment\_script | OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment | `string` | `""` | no |
| primary\_startup\_url | Startup script to be executed when the VM boots, should not be overridden | `string` | `"curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_maxdb/startup.sh | bash -x -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"` | no |
| project\_id | Project id where the instances will be created | `string` | n/a | yes |
| public\_ip | OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail | `bool` | `true` | no |
| reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| sap\_deployment\_debug | OPTIONAL - If this value is set to anything, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging | `bool` | `false` | no |
| sap\_mnt\_size | OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the ase database instance. If set to 0, no disk will be created | `number` | `0` | no |
| service\_account | OPTIONAL - Ability to define a custom service account instead of using the default project service account | `string` | `""` | no |
| subnetwork | The sub network to deploy the instance in | `string` | n/a | yes |
| swap\_size | OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the ase database instance. If set to 0, no disk will be created | `number` | `0` | no |
| usr\_sap\_size | OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the ase database instance. If set to 0, no disk will be created | `number` | `0` | no |
| zone | Zone to create the resources in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_maxdb\_self\_link | SAP MaxDB self-link for instance created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->