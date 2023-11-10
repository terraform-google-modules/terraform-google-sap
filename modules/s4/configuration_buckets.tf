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

data "google_storage_bucket" "configuration" {
  name = var.configuration_bucket_name == "" ? "${var.gcp_project_id}-${var.deployment_name}-configuration" : var.configuration_bucket_name
}

resource "google_storage_bucket_iam_binding" "objectviewer_configuration" {
  bucket = data.google_storage_bucket.configuration.name
  members = [
    "serviceAccount:${google_service_account.service_account_ansible.email}"
  ]
  role = "roles/storage.objectViewer"
}

resource "google_storage_bucket_object" "ansible_inventory" {
  bucket = data.google_storage_bucket.configuration.name
  content = jsonencode({
    "ansible_runner" : {
      "children" : {
        "all_generic" : {
          "children" : {
            "${var.deployment_name}_ansible" : {
              "children" : {
                "ansible" : {
                  "hosts" : {
                    "${var.deployment_name}-ansible-runner" : {
                      "gce_instance_labels" : {
                        "active_region" : true,
                        "component" : "ansible",
                        "component_type" : "generic",
                        "environment" : "${var.deployment_name}",
                        "service_group" : "ansible_runner"
                      },
                      "gce_instance_metadata" : {
                        "active_region" : true,
                        "configuration_bucket_name" : "${data.google_storage_bucket.configuration.name}",
                        "dns_zone_name" : "${data.google_dns_managed_zone.sap_zone.name}",
                        "is_test" : "${var.is_test}",
                        "media_bucket_name" : "${var.media_bucket_name}",
                        "startup-script" : "gsutil cp ${var.primary_startup_url} ./local_startup.sh; bash local_startup.sh ${var.package_location} ${var.deployment_name}"
                      },
                      "gce_instance_name" : "${var.deployment_name}-ansible-runner",
                      "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                      "gce_instance_zone" : "${var.zone1_name}"
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "s4" : {
      "children" : {
        "all_app" : {
          "children" : {
            "${var.deployment_name}_app" : {
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
                          "application_secret_name" : "${var.application_secret_name}",
                          "dns_name" : "${data.google_dns_managed_zone.sap_zone.dns_name}",
                          "dns_zone_name" : "${data.google_dns_managed_zone.sap_zone.name}",
                          "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                          "hana_secret_name" : "${var.hana_secret_name}",
                          "media_bucket_name" : "${var.media_bucket_name}",
                          "sap_instance_id_app" : "${var.sap_instance_id_app}",
                          "sap_instance_id_ascs" : "${var.sap_instance_id_ascs}",
                          "sap_instance_id_db" : "${var.sap_instance_id_db}",
                          "sap_version" : "${var.sap_version}",
                          "sid_app" : "${var.app_sid}",
                          "sid_hana" : "${var.db_sid}"
                        },
                        "gce_instance_name" : "${var.vm_prefix}app1${1 + (count.index * 2)}",
                        "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                        "gce_instance_zone" : "${var.zone1_name}"
                      }
                    }
                  ]...)
                }
              }
            }
          }
        },
        "all_ascs" : {
          "children" : {
            "${var.deployment_name}_ascs" : {
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
                        "application_secret_name" : "${var.application_secret_name}",
                        "dns_name" : "${data.google_dns_managed_zone.sap_zone.dns_name}",
                        "dns_zone_name" : "${data.google_dns_managed_zone.sap_zone.name}",
                        "failover_type" : "NONE",
                        "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                        "hana_secret_name" : "${var.hana_secret_name}",
                        "media_bucket_name" : "${var.media_bucket_name}",
                        "sap_instance_id_app" : "${var.sap_instance_id_app}",
                        "sap_instance_id_ascs" : "${var.sap_instance_id_ascs}",
                        "sap_instance_id_db" : "${var.sap_instance_id_db}",
                        "sap_version" : "${var.sap_version}",
                        "sid_app" : "${var.app_sid}",
                        "sid_hana" : "${var.db_sid}"
                      },
                      "gce_instance_name" : "${var.vm_prefix}ascs11",
                      "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                      "gce_instance_zone" : "${var.zone1_name}"
                    }
                  }
                }
              }
            }
          }
        },
        "all_db" : {
          "children" : {
            "${var.deployment_name}_db" : {
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
                        "application_secret_name" : "${var.application_secret_name}",
                        "dns_name" : "${data.google_dns_managed_zone.sap_zone.dns_name}",
                        "dns_zone_name" : "${data.google_dns_managed_zone.sap_zone.name}",
                        "fstore_url" : "${google_dns_record_set.sap_fstore_1.name}:/${google_filestore_instance.sap_fstore_1.file_shares[0].name}",
                        "hana_secret_name" : "${var.hana_secret_name}",
                        "hdx_hana_config" : "${local.hdx_hana_config}",
                        "media_bucket_name" : "${var.media_bucket_name}",
                        "sap_instance_id_app" : "${var.sap_instance_id_app}",
                        "sap_instance_id_ascs" : "${var.sap_instance_id_ascs}",
                        "sap_instance_id_db" : "${var.sap_instance_id_db}",
                        "sap_version" : "${var.sap_version}",
                        "sid_app" : "${var.app_sid}",
                        "sid_hana" : "${var.db_sid}"
                      },
                      "gce_instance_name" : "${var.vm_prefix}db11",
                      "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                      "gce_instance_zone" : "${var.zone1_name}"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  })
  name = var.configuration_bucket_name == "" ? "wlm.${var.deployment_name}.yml" : "${var.gcp_project_id}-${var.deployment_name}-configuration/wlm.${var.deployment_name}.yml"
}
