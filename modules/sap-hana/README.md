
[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autodelete\_disk | Delete backend disk along with instance | string | `"true"` | no |
| boot\_disk\_size | Root disk size in GB | string | n/a | yes |
| boot\_disk\_type | The type of data disk: PD_SSD or PD_HDD. | string | n/a | yes |
| instance\_name | Compute Engine instance name | string | n/a | yes |
| instance\_type | Compute Engine instance Type | string | n/a | yes |
| linux\_image\_family | Compute Engine image name | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image | string | n/a | yes |
| network\_tags | List of network tags | list | `<list>` | no |
| pd\_ssd\_size | Persistent disk size in GB | string | n/a | yes |
| pd\_standard\_size | Persistent disk size in GB | string | n/a | yes |
| post\_deployment\_script | SAP post deployment script | string | n/a | yes |
| project\_id | Project id to deploy the resources | string | n/a | yes |
| region | Region to deploy the resources | string | n/a | yes |
| sap\_deployment\_debug | SAP hana deployment debug | string | `"false"` | no |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket | string | n/a | yes |
| sap\_hana\_instance\_number | SAP hana instance number | string | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP hana sap system gid | string | n/a | yes |
| sap\_hana\_sid | SAP hana SID | string | n/a | yes |
| sap\_hana\_sidadm\_password | SAP hana SID admin password | string | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP hana sid adm password | string | n/a | yes |
| sap\_hana\_system\_password | SAP hana system password | string | n/a | yes |
| service\_account | Service to run the terrform | string | n/a | yes |
| subnetwork | Compute Engine instance name | string | n/a | yes |
| zone | Compute Engine instance deployment zone | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gcp\_sap\_hana\_instance\_machine\_type |  |
| instance\_gcp\_sap\_hana\_name |  |
| instance\_zone |  |

[^]: (autogen_docs_end)
