<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| can\_ip\_forward | Whether sending and receiving of packets with non-matching source or destination IPs is allowed. | `bool` | `true` | no |
| db2\_backup\_size | OPTIONAL - Size in GB of the /db2backup - If set to 0, no disk will be created. | `number` | `0` | no |
| db2\_dump\_size | Size in GB of /db2/[DBSID]/db2dump - this directory holds dump files from DB2 which may be useful for diagnosing problems. | `number` | `8` | no |
| db2\_home\_size | Size in GB of /db2/db2[DBSID] - the home directory of the database instance. | `number` | `8` | no |
| db2\_log\_size | Size in GB of /db2/[DBSID]/logdir - Which holds the database transaction logs. | `number` | `8` | no |
| db2\_log\_ssd | SSD toggle for the log drive. If set to true, the log disk will be SSD. | `bool` | `true` | no |
| db2\_sap\_data\_size | Size in GB of /db2/[DBSID]/sapdata - Which holds the database data files. | `number` | `30` | no |
| db2\_sap\_data\_ssd | SSD toggle for the data drive. If set to true, the data disk will be SSD. | `bool` | `true` | no |
| db2\_sap\_temp\_size | Size in GB of /db2/[DBSID]/saptmp - Which holds the database temporary table space. | `number` | `8` | no |
| db2\_sid | The database instance/SID name. | `string` | n/a | yes |
| db2\_sid\_size | Size in GB of /db2/[DBSID] - the root directory of the database instance. | `number` | `8` | no |
| instance\_name | Hostname of the GCE instance. | `string` | n/a | yes |
| linux\_image | Linux image name to use. | `string` | n/a | yes |
| linux\_image\_project | The project which the Linux image belongs to. | `string` | n/a | yes |
| machine\_type | Machine type for the instances. | `string` | n/a | yes |
| network\_tags | OPTIONAL - Network tags can be associated to your instance on deployment. This can be used for firewalling or routing purposes. | `list(string)` | `[]` | no |
| post\_deployment\_script | OPTIONAL - gs:// or https:// location of a script to execute on the created VM's post deployment. | `string` | `""` | no |
| primary\_startup\_url | Startup script to be executed when the VM boots, should not be overridden. | `string` | `"curl -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform/sap_db2/startup.sh | bash -x -s https://storage.googleapis.com/cloudsapdeploy/terraform/latest/terraform"` | no |
| project\_id | Project id where the instances will be created. | `string` | n/a | yes |
| public\_ip | OPTIONAL - Defines whether a public IP address should be added to your VM. By default this is set to Yes. Note that if you set this to No without appropriate network nat and tags in place, there will be no route to the internet and thus the installation will fail. | `bool` | `true` | no |
| reservation\_name | Use a reservation specified by RESERVATION\_NAME.<br>By default ANY\_RESERVATION is used when this variable is empty.<br>In order for a reservation to be used it must be created with the<br>"Select specific reservation" selected (specificReservationRequired set to true)<br>Be sure to create your reservation with the correct Min CPU Platform for the<br>following instance types:<br>n1-highmem-32 : Intel Broadwell<br>n1-highmem-64 : Intel Broadwell<br>n1-highmem-96 : Intel Skylake<br>n1-megamem-96 : Intel Skylake<br>m1-megamem-96 : Intel Skylake<br>All other instance types can have automatic Min CPU Platform" | `string` | `""` | no |
| sap\_deployment\_debug | OPTIONAL - If this value is set to true, the deployment will generates verbose deployment logs. Only turn this setting on if a Google support engineer asks you to enable debugging. | `bool` | `false` | no |
| sap\_mnt\_size | OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the db2 database instance. If set to 0, no disk will be created. | `number` | `0` | no |
| service\_account | OPTIONAL - Ability to define a custom service account instead of using the default project service account. | `string` | `""` | no |
| subnetwork | The sub network to deploy the instance in. | `string` | n/a | yes |
| swap\_size | OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the db2 database instance. If set to 0, no disk will be created. | `number` | `0` | no |
| usr\_sap\_size | OPTIONAL - Only required if you plan on deploying SAP NetWeaver on the same VM as the db2 database instance. If set to 0, no disk will be created. | `number` | `0` | no |
| zone | Zone where the instances will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sap\_db2\_instance\_self\_link | DB2 self-link for instance created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->