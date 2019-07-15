
# SAP HANA ScaleOut Submodule

This module deals with SAP HANA ScaleOut configuration and deployment.

## Usage

The resources/services/activations/deletions that this module will create/trigger are:

- Create a Master Node and multiple Worker Nodes that will host SAP HANA Scaleout Module
- Create a Static IP Address for each of the Compute Instance
- Create 2 Persistent Disks on each node to host SAP HANA Scaleout's File systems


You can go in the [examples](../../examples) folder complete working example. However, here's an example of how to use the module in a main.tf file.

```hcl
provider "google" {
  version = "~> 2.6.0"
  region  = "${var.region}"
}

module "gcp_sap_hana_scaleout" {
  source                     = "terraform-google-modules/sap/google/sap_hana_scaleout"
  subnetwork                 = "${var.subnetwork}"
  linux_image_family         = "${var.linux_image_family}"
  linux_image_project        = "${var.linux_image_project}"
  instance_type              = "${var.instance_type}"
  network_tags               = "${var.network_tags}"
  project_id                 = "${var.project_id}"
  region                     = "${var.region}"
  service_account_email      = "${var.service_account_email}"
  boot_disk_size             = "${var.boot_disk_size}"
  boot_disk_type             = "${var.boot_disk_type}"
  autodelete_disk            = "${var.autodelete_disk}"
  pd_ssd_size                = "${var.pd_ssd_size}"
  pd_hdd_size                = "${var.pd_hdd_size}"
  disk_type_0                = "${var.disk_type_0}"
  disk_type_1                = "${var.disk_type_1}"
  sap_deployment_debug       = "false"
  post_deployment_script     = "${var.post_deployment_script}"
  sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
  post_deployment_script     = "${var.post_deployment_script}"
  sap_hana_sid               = "${var.sap_hana_sid}"
  sap_hana_instance_number   = "${var.sap_hana_instance_number}"
  sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
  sap_hana_system_password   = "${var.sap_hana_system_password}"
  sap_hana_sidadm_uid        = 900
  sap_hana_sapsys_gid        = 900
  sap_hana_scaleout_nodes    = "${var.sap_hana_scaleout_nodes}"
  zone                       = "${var.zone}"
  instance_count_master      = "${var.instance_count_master}"
  instance_count_worker      = "${var.instance_count_worker}"
  instance_name              = "${var.instance_name}"
  startup_script_1           = "${var.startup_script_1}"
  startup_script_2           = "${var.startup_script_2}"
}
```
## Requirements

Make sure you've gone through the root [Requirement Section](../../README.md#requirements)

### SAP HANA Software
 Follow instructions [here](https://cloud.google.com/solutions/sap/docs/sap-hana-deployment-guide#creating_a_cloud_storage_bucket_for_the_sap_hana_installation_files) to properly Download SAP HANA from the SAP Marketplace, and upload it to a GCS bucket.


### Configure Service Account for identifying the Compute instances
The compute instances created by this submodule will need to download SAP HANA from a GCS bucket in order install it. Follow the instructions below to ensure a successful installation:

 1. [Create a new service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
 2. Grant this new service account the following permissions on the bucket where you uploaded SAP HANA installation file:
    - roles/storage.objectViewer

 You may use the following gcloud commands:
   `gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:<service-account-email> --role=roles/storage.objectViewer`

3. When configuring the module, use this newly created service account's email, to set the `service_account_email` input variable.

### Post deployment script
If you need to run a post deployment script, the script needs to be accessible via a **https:// or gs:// URl**.
It is the recommended way is to use a GCS Bucket in the following way.:

1. Upload the SAP HANA software to a GCS bucket.
2. Make sure the service account attached to the instance has the following permissions on the bucket:
   - roles/storage.objectViewer
     - Note that this permission should already be granted if the bucket is in the same project as the one where you created the service account previously.

3. Set the post_deployment_script input to the gs:// link to your script. (i.e gs://<bucket_name>/<my_script>)


[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autodelete\_disk | Whether the disk will be auto-deleted when the instance is deleted. | string | `"false"` | no |
| boot\_disk\_size | Root disk size in GB. | string | n/a | yes |
| boot\_disk\_type | The GCE boot disk type. May be set to pd-standard (for PD HDD) or pd-ssd. | string | n/a | yes |
| device\_name\_boot | device name for boot disk | string | `"boot"` | no |
| device\_name\_pd\_hdd | device name for standard persistant disk | string | `"pdhdd"` | no |
| device\_name\_pd\_ssd | device name for ssd persistant disk | string | `"pdssd"` | no |
| disk\_type\_0 | The GCE data disk type. May be set to pd-ssd. | string | `""` | no |
| disk\_type\_1 | The GCE data disk type. May be set to pd-standard (for PD HDD). | string | `""` | no |
| instance\_count\_master | Compute Engine instance count | string | n/a | yes |
| instance\_count\_worker | Compute Engine instance count | string | n/a | yes |
| instance\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | string | n/a | yes |
| instance\_type | The GCE instance/machine type. | string | n/a | yes |
| linux\_image\_family | GCE image family. | string | n/a | yes |
| linux\_image\_project | Project name containing the linux image | string | n/a | yes |
| network\_tags | List of network tags to attach to the instance. | list | `<list>` | no |
| pd\_hdd\_size | Persistent Standard disk size in GB | string | n/a | yes |
| pd\_ssd\_size | Persistent disk size in GB | string | n/a | yes |
| post\_deployment\_script | SAP post deployment script | string | `""` | no |
| project\_id | The ID of the project in which the resources will be deployed. | string | n/a | yes |
| region | Region to deploy the resources. Should be in the same region as the zone. | string | n/a | yes |
| sap\_deployment\_debug | SAP hana deployment debug | string | n/a | yes |
| sap\_hana\_deployment\_bucket | SAP hana deployment bucket | string | n/a | yes |
| sap\_hana\_instance\_number | SAP hana instance number | string | n/a | yes |
| sap\_hana\_sapsys\_gid | SAP hana sap system gid | string | n/a | yes |
| sap\_hana\_scaleout\_nodes | SAP hana scaleout nodes | string | n/a | yes |
| sap\_hana\_sid | SAP hana SID | string | n/a | yes |
| sap\_hana\_sidadm\_password | SAP hana SID admin password | string | n/a | yes |
| sap\_hana\_sidadm\_uid | SAP hana sid adm password | string | n/a | yes |
| sap\_hana\_system\_password | SAP hana system password | string | n/a | yes |
| service\_account\_email | Email of service account to attach to the instance. | string | n/a | yes |
| startup\_script\_1 | Startup script to install SAP HANA. | string | n/a | yes |
| startup\_script\_2 | Startup script to install SAP HANA. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork where the isntance will be deployed. The subnetwork must exist in the same region this instance will be created in. | string | n/a | yes |
| zone | The zone that the instance should be created in. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_master\_machine\_type | instance master type |
| instance\_master\_name | Name of primary instance |
| instance\_master\_zone | Compute Engine primary instance deployment zone |
| instance\_worker\_first\_node\_name | instance worker first node name |
| instance\_worker\_second\_node\_name | instance worker second node name |
| worker\_instance\_machine\_type | instance worker machine type |
| worker\_instance\_zone | instance worker zone |

[^]: (autogen_docs_end)
