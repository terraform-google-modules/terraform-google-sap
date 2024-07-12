# Copyright 2024 Google LLC
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
  name = var.configuration_bucket_name == "" ? resource.google_storage_bucket.configuration[0].name : var.configuration_bucket_name
}

resource "google_storage_bucket_iam_binding" "objectviewer_configuration" {
  bucket = data.google_storage_bucket.configuration.name
  members = [
    "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  ]
  role = "roles/storage.objectViewer"
}

locals {
  hana_endpoint = var.deployment_has_dns ? "sapddb-vip11.${data.google_dns_managed_zone.sap_zone[0].dns_name}" : "sapddb-vip11"
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
                        "environment" : var.deployment_name,
                        "service_group" : "ansible_runner"
                      },
                      "gce_instance_metadata" : {
                        "active_region" : "true",
                        "configuration_bucket_name" : data.google_storage_bucket.configuration.name,
                        "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                        "deployment_has_dns" : var.deployment_has_dns,
                        "is_test" : var.is_test,
                        "media_bucket_name" : var.media_bucket_name,
                        "startup-script" : "gsutil cp ${var.primary_startup_url} ./local_startup.sh; bash local_startup.sh ${var.package_location} ${var.deployment_name}",
                        "template_name" : "s4_ha",
                        "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                        "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                        "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                        "hana_sr_ilb_url" : local.hana_endpoint,
                      },
                      "gce_instance_name" : "${var.deployment_name}-ansible-runner",
                      "gce_instance_project" : data.google_project.sap-project.project_id,
                      "gce_instance_zone" : var.zone1_name,
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
                      (length(var.app_vm_names) > (0 + (count.index * 2)) ? var.app_vm_names[0 + (count.index * 2)] : "${var.vm_prefix}app1${1 + (count.index * 2)}") : {
                        "gce_instance_labels" : {
                          "active_region" : true,
                          "component" : "app",
                          "component_type" : "app",
                          "environment" : var.deployment_name,
                          "service_group" : "s4"
                        },
                        "gce_instance_metadata" : {
                          "active_region" : "true",
                          "application_secret_name" : var.application_secret_name,
                          "fstore_url" : local.fstore_url1,
                          "dns_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].dns_name : "",
                          "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                          "deployment_has_dns" : var.deployment_has_dns,
                          "hana_secret_name" : var.hana_secret_name,
                          "hdx_hana_config" : var.app_disk_type == "hyperdisk-extreme" ? true : false,
                          "media_bucket_name" : var.media_bucket_name,
                          "sap_instance_id_app" : var.sap_instance_id_app,
                          "sap_instance_id_ascs" : var.sap_instance_id_ascs,
                          "sap_instance_id_db" : var.sap_instance_id_db,
                          "sap_instance_id_ers" : var.sap_instance_id_ers,
                          "sap_version" : var.sap_version,
                          "sid_app" : var.app_sid,
                          "sid_hana" : var.db_sid,
                          "template_name" : "s4_ha",
                          "virtualize_disks" : var.virtualize_disks,
                          "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                          "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                          "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                          "hana_sr_ilb_url" : local.hana_endpoint,
                        },
                        "gce_instance_name" : length(var.app_vm_names) > (0 + (count.index * 2)) ? var.app_vm_names[0 + (count.index * 2)] : "${var.vm_prefix}app1${1 + (count.index * 2)}",
                        "gce_instance_project" : data.google_project.sap-project.project_id,
                        "gce_instance_zone" : var.zone1_name,
                        "ip_address" : google_compute_instance.sapdapp11[count.index].network_interface[0].network_ip
                      },
                      (length(var.app_vm_names) > (1 + (count.index * 2)) ? var.app_vm_names[1 + (count.index * 2)] : "${var.vm_prefix}app1${2 + (count.index * 2)}") : {
                        "gce_instance_labels" : {
                          "active_region" : true,
                          "component" : "app",
                          "component_type" : "app",
                          "environment" : var.deployment_name,
                          "service_group" : "s4"
                        },
                        "gce_instance_metadata" : {
                          "active_region" : "true",
                          "application_secret_name" : var.application_secret_name,
                          "fstore_url" : local.fstore_url1,
                          "dns_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].dns_name : "",

                          "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                          "deployment_has_dns" : var.deployment_has_dns,
                          "hana_secret_name" : var.hana_secret_name,
                          "hdx_hana_config" : var.app_disk_type == "hyperdisk-extreme" ? true : false,
                          "media_bucket_name" : var.media_bucket_name,
                          "sap_instance_id_app" : var.sap_instance_id_app,
                          "sap_instance_id_ascs" : var.sap_instance_id_ascs,
                          "sap_instance_id_db" : var.sap_instance_id_db,
                          "sap_instance_id_ers" : var.sap_instance_id_ers,
                          "sap_version" : var.sap_version,
                          "sid_app" : var.app_sid,
                          "sid_hana" : var.db_sid,
                          "template_name" : "s4_ha",
                          "virtualize_disks" : var.virtualize_disks,
                          "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                          "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                          "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                          "hana_sr_ilb_url" : local.hana_endpoint,
                        },
                        "gce_instance_name" : length(var.app_vm_names) > (1 + (count.index * 2)) ? var.app_vm_names[1 + (count.index * 2)] : "${var.vm_prefix}app1${2 + (count.index * 2)}",
                        "gce_instance_project" : data.google_project.sap-project.project_id,
                        "gce_instance_zone" : var.zone2_name,
                        "ip_address" : google_compute_instance.sapdapp12[count.index].network_interface[0].network_ip
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
                    (length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11") : {
                      "gce_instance_labels" : {
                        "active_region" : true,
                        "component" : "ascs",
                        "component_type" : "ascs",
                        "environment" : var.deployment_name,
                        "service_group" : "s4"
                      },
                      "gce_instance_metadata" : {
                        "active_region" : "true",
                        "application_secret_name" : var.application_secret_name,
                        "ascs_healthcheck_port" : var.ascs_ilb_healthcheck_port,
                        "dns_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].dns_name : "",

                        "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                        "deployment_has_dns" : var.deployment_has_dns,
                        "ers_healthcheck_port" : var.ers_ilb_healthcheck_port,
                        "failover_type" : "ILB",
                        "fstore_url" : local.fstore_url1,
                        "hana_secret_name" : var.hana_secret_name,
                        "hdx_hana_config" : var.ascs_disk_type == "hyperdisk-extreme" ? true : false,
                        "media_bucket_name" : var.media_bucket_name,
                        "pacemaker_scenario" : "ON",
                        "sap_instance_id_app" : var.sap_instance_id_app,
                        "sap_instance_id_ascs" : var.sap_instance_id_ascs,
                        "sap_instance_id_db" : var.sap_instance_id_db,
                        "sap_instance_id_ers" : var.sap_instance_id_ers,
                        "sap_version" : var.sap_version,
                        "sid_app" : var.app_sid,
                        "sid_hana" : var.db_sid,
                        "template_name" : "s4_ha",
                        "virtualize_disks" : var.virtualize_disks,
                        "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                        "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                        "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                        "hana_sr_ilb_url" : local.hana_endpoint,
                      },
                      "gce_instance_name" : length(var.ascs_vm_names) > 0 ? var.ascs_vm_names[0] : "${var.vm_prefix}ascs11",
                      "gce_instance_project" : data.google_project.sap-project.project_id,
                      "gce_instance_zone" : var.zone1_name,
                      "ip_address" : google_compute_instance.sapdascs11.network_interface[0].network_ip
                    },
                    (length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12") : {
                      "gce_instance_labels" : {
                        "active_region" : true,
                        "component" : "ascs",
                        "component_type" : "ascs",
                        "environment" : var.deployment_name,
                        "service_group" : "s4"
                      },
                      "gce_instance_metadata" : {
                        "active_region" : "true",
                        "application_secret_name" : var.application_secret_name,
                        "ascs_healthcheck_port" : var.ascs_ilb_healthcheck_port,
                        "dns_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].dns_name : "",
                        "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                        "deployment_has_dns" : var.deployment_has_dns,
                        "ers_healthcheck_port" : var.ers_ilb_healthcheck_port,
                        "failover_type" : "ILB",
                        "fstore_url" : local.fstore_url1,
                        "hana_secret_name" : var.hana_secret_name,
                        "hdx_hana_config" : var.ascs_disk_type == "hyperdisk-extreme" ? true : false,
                        "media_bucket_name" : var.media_bucket_name,
                        "pacemaker_scenario" : "ON",
                        "sap_instance_id_app" : var.sap_instance_id_app,
                        "sap_instance_id_ascs" : var.sap_instance_id_ascs,
                        "sap_instance_id_db" : var.sap_instance_id_db,
                        "sap_instance_id_ers" : var.sap_instance_id_ers,
                        "sap_version" : var.sap_version,
                        "sid_app" : var.app_sid,
                        "sid_hana" : var.db_sid,
                        "template_name" : "s4_ha",
                        "virtualize_disks" : var.virtualize_disks,
                        "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                        "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                        "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                        "hana_sr_ilb_url" : local.hana_endpoint,
                      },
                      "gce_instance_name" : length(var.ascs_vm_names) > 1 ? var.ascs_vm_names[1] : "${var.vm_prefix}ascs12",
                      "gce_instance_project" : data.google_project.sap-project.project_id,
                      "gce_instance_zone" : var.zone2_name,
                      "ip_address" : google_compute_instance.sapdascs12.network_interface[0].network_ip
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
                    (length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11") : {
                      "gce_instance_labels" : {
                        "active_region" : true,
                        "component" : "db",
                        "component_type" : "db",
                        "environment" : var.deployment_name,
                        "service_group" : "s4"
                      },
                      "gce_instance_metadata" : {
                        "active_region" : "true",
                        "application_secret_name" : var.application_secret_name,
                        "data_stripe_size" : var.data_stripe_size,
                        "fstore_url" : local.fstore_url1,
                        "dns_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].dns_name : "",

                        "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                        "deployment_has_dns" : var.deployment_has_dns,
                        "ha_sr_pcs_scenario" : "ON",
                        "hana_secret_name" : var.hana_secret_name,
                        "hana_sr_failover_type" : "ILB",
                        "hana_sr_ilb_url" : local.hana_endpoint,
                        "hana_sr_is_active_region" : "true",
                        "hana_sr_remote_host" : "",
                        "hana_sr_tier" : "1",
                        "hana_sr_tier1_dns_target" : local.hana_endpoint,
                        "hdx_hana_config" : var.db_disk_type == "hyperdisk-extreme" ? true : false,
                        "ilb_healthcheck_port" : var.db_ilb_healthcheck_port,
                        "log_stripe_size" : var.log_stripe_size,
                        "media_bucket_name" : var.media_bucket_name,
                        "sap_instance_id_app" : var.sap_instance_id_app,
                        "sap_instance_id_ascs" : var.sap_instance_id_ascs,
                        "sap_instance_id_db" : var.sap_instance_id_db,
                        "sap_instance_id_ers" : var.sap_instance_id_ers,
                        "sap_version" : var.sap_version,
                        "sid_app" : var.app_sid,
                        "sid_hana" : var.db_sid,
                        "template_name" : "s4_ha",
                        "virtualize_disks" : var.virtualize_disks,
                        "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                        "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                        "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                        "hana_sr_ilb_url" : local.hana_endpoint,
                      },
                      "gce_instance_name" : length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11",
                      "gce_instance_project" : data.google_project.sap-project.project_id,
                      "gce_instance_zone" : var.zone1_name,
                      "ip_address" : google_compute_instance.sapddb11.network_interface[0].network_ip
                    },
                    (length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12") : {
                      "gce_instance_labels" : {
                        "active_region" : true,
                        "component" : "db",
                        "component_type" : "db",
                        "environment" : var.deployment_name,
                        "service_group" : "s4"
                      },
                      "gce_instance_metadata" : {
                        "active_region" : "true",
                        "application_secret_name" : var.application_secret_name,
                        "data_stripe_size" : var.data_stripe_size,
                        "fstore_url" : local.fstore_url1,
                        "dns_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].dns_name : "",
                        "dns_zone_name" : var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : "",
                        "deployment_has_dns" : var.deployment_has_dns,
                        "ha_sr_pcs_scenario" : "ON",
                        "hana_secret_name" : var.hana_secret_name,
                        "hana_sr_failover_type" : "ILB",
                        "hana_sr_ilb_url" : local.hana_endpoint,
                        "hana_sr_is_active_region" : "true",
                        "hana_sr_remote_host" : length(var.db_vm_names) > 0 ? var.db_vm_names[0] : "${var.vm_prefix}db11",
                        "hana_sr_tier" : "2",
                        "hana_sr_tier1_dns_target" : local.hana_endpoint,
                        "hdx_hana_config" : local.hdx_hana_config,
                        "hdx_hana_config" : var.db_disk_type == "hyperdisk-extreme" ? true : false,
                        "ilb_healthcheck_port" : var.db_ilb_healthcheck_port,
                        "log_stripe_size" : var.log_stripe_size,
                        "media_bucket_name" : var.media_bucket_name,
                        "sap_instance_id_app" : var.sap_instance_id_app,
                        "sap_instance_id_ascs" : var.sap_instance_id_ascs,
                        "sap_instance_id_db" : var.sap_instance_id_db,
                        "sap_instance_id_ers" : var.sap_instance_id_ers,
                        "sap_version" : var.sap_version,
                        "sid_app" : var.app_sid,
                        "sid_hana" : var.db_sid,
                        "template_name" : "s4_ha",
                        "virtualize_disks" : var.virtualize_disks
                        "ascs_forwarding_ip" : google_compute_forwarding_rule.ascs_forwarding_rule.ip_address,
                        "ers_forwarding_ip" : google_compute_forwarding_rule.ers_forwarding_rule.ip_address,
                        "db_forwarding_ip" : google_compute_forwarding_rule.db_forwarding_rule.ip_address,
                        "hana_sr_ilb_url" : local.hana_endpoint,
                        //  "fstore_name" : "${google_filestore_instance.sap_fstore_1.name}",
                        // "fstore_ip" : "${google_filestore_instance.sap_fstore_1.networks[0].ip_addresses[0]}",
                      },
                      "gce_instance_name" : length(var.db_vm_names) > 1 ? var.db_vm_names[1] : "${var.vm_prefix}db12",
                      "gce_instance_project" : data.google_project.sap-project.project_id,
                      "gce_instance_zone" : var.zone2_name,
                      "ip_address" : google_compute_instance.sapddb12.network_interface[0].network_ip
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
