# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_storage_bucket" "configuration" {
  location                    = "US"
  name                        = "${var.gcp_project_name}-${var.deployment_name}_configuration"
  project                     = data.google_project.sap-project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "objectviewer_configuration" {
  bucket = google_storage_bucket.configuration.name
  members = [
    "serviceAccount:${google_service_account.service_account_jump.email}"
  ]
  role = "roles/storage.objectViewer"
}

resource "google_storage_bucket_object" "ansible_inventory" {
  bucket = "${var.gcp_project_name}-${var.deployment_name}_configuration"
  content = jsonencode({
    "s4" : {
      "children" : {
        "all_app" : {
          "children" : {
            "app" : {
              "hosts" : merge([for count in [for i in range(var.app_vms_multiplier) : { index : i }] :
                {
                  "${var.vm_prefix}app1${1 + (count.index * 2)}" : {
                    "gce_instance_labels" : {
                      "active_region" : true,
                      "component" : "app",
                      "component_type" : "app",
                      "environment" : "${var.deployment_name}",
                      "service_group" : "s4"
                    },
                    "gce_instance_metadata" : {
                      "active_region" : true,
                      "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                      "sid" : "${var.app_sid}"
                    },
                    "gce_instance_name" : "${var.vm_prefix}app1${1 + (count.index * 2)}",
                    "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                    "gce_instance_zone" : "${var.zone1_name}"
                  },
                  "${var.vm_prefix}app1${2 + (count.index * 2)}" : {
                    "gce_instance_labels" : {
                      "active_region" : true,
                      "component" : "app",
                      "component_type" : "app",
                      "environment" : "${var.deployment_name}",
                      "service_group" : "s4"
                    },
                    "gce_instance_metadata" : {
                      "active_region" : true,
                      "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                      "sid" : "${var.app_sid}"
                    },
                    "gce_instance_name" : "${var.vm_prefix}app1${2 + (count.index * 2)}",
                    "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                    "gce_instance_zone" : "${var.zone2_name}"
                  }
                }
              ]...)
            }
          }
        },
        "all_ascs" : {
          "children" : {
            "ascs" : {
              "hosts" : {
                "${var.vm_prefix}ascs11" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "ascs",
                    "component_type" : "ascs",
                    "environment" : "${var.deployment_name}",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                    "sid" : "${var.app_sid}"
                  },
                  "gce_instance_name" : "${var.vm_prefix}ascs11",
                  "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                  "gce_instance_zone" : "${var.zone1_name}"
                },
                "${var.vm_prefix}ascs12" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "ascs",
                    "component_type" : "ascs",
                    "environment" : "${var.deployment_name}",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                    "sid" : "${var.app_sid}"
                  },
                  "gce_instance_name" : "${var.vm_prefix}ascs12",
                  "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                  "gce_instance_zone" : "${var.zone2_name}"
                }
              }
            }
          }
        },
        "all_db" : {
          "children" : {
            "db" : {
              "hosts" : {
                "${var.vm_prefix}db11" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "db",
                    "component_type" : "db",
                    "environment" : "${var.deployment_name}",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                    "ha_sr_pcs_scenario" : "ON",
                    "hana_sr_failover_type" : "ILB",
                    "hana_sr_is_active_region" : true,
                    "hana_sr_remote_host" : "",
                    "hana_sr_tier" : 1,
                    "hana_sr_tier1_dns_target" : "sapddb-vip11.${google_dns_managed_zone.sap_zone.dns_name}",
                    "sid" : "${var.db_sid}",
                    "sid_tenant" : "${var.app_sid}"
                  },
                  "gce_instance_name" : "${var.vm_prefix}db11",
                  "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                  "gce_instance_zone" : "${var.zone1_name}"
                },
                "${var.vm_prefix}db12" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "db",
                    "component_type" : "db",
                    "environment" : "${var.deployment_name}",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                    "ha_sr_pcs_scenario" : "ON",
                    "hana_sr_failover_type" : "ILB",
                    "hana_sr_is_active_region" : true,
                    "hana_sr_remote_host" : "${var.vm_prefix}db11",
                    "hana_sr_tier" : 2,
                    "hana_sr_tier1_dns_target" : "sapddb-vip11.${google_dns_managed_zone.sap_zone.dns_name}",
                    "sid" : "${var.db_sid}",
                    "sid_tenant" : "${var.app_sid}"
                  },
                  "gce_instance_name" : "${var.vm_prefix}db12",
                  "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                  "gce_instance_zone" : "${var.zone2_name}"
                }
              }
            }
          }
        }
      }
    }
  })
  name = "wlm.${var.deployment_name}.yml"
}
