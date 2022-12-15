


resource "google_storage_bucket" "core-connect-dev-configuration" {
  location                    = "US"
  name                        = "core-connect-dev-configuration"
  project                     = data.google_project.sap-project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}


resource "google_storage_bucket_iam_binding" "objectViewer-core-connect-dev-configuration" {
  bucket = google_storage_bucket.core-connect-dev-configuration.name
  members = [
    "serviceAccount:${google_service_account.service-account-sap-app-role-s4test.email}"
  ]
  role = "roles/storage.objectViewer"
}

resource "google_storage_bucket_object" "ansible-inventory" {
  bucket = "core-connect-dev-configuration"
  content = jsonencode({
    "all_app" : {
      "children" : {
        "app" : {
          "children" : {
            "s4test_app" : {
              "hosts" : {
                "${var.vm_prefix}app11" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "app",
                    "component_type" : "app",
                    "environment" : "s4test",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "sid" : "ED1"
                  },
                  "gce_instance_name" : "${var.vm_prefix}app11",
                  "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                  "gce_instance_zone" : "${var.zone1_name}"
                }
              }
            }
          }
        }
      }
    },
    "all_ascs" : {
      "children" : {
        "ascs" : {
          "children" : {
            "s4test_ascs" : {
              "hosts" : {
                "${var.vm_prefix}ascs11" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "ascs",
                    "component_type" : "ascs",
                    "environment" : "s4test",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "sid" : "ED1"
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
                    "environment" : "s4test",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "sid" : "ED1"
                  },
                  "gce_instance_name" : "${var.vm_prefix}ascs12",
                  "gce_instance_project" : "${data.google_project.sap-project.project_id}",
                  "gce_instance_zone" : "${var.zone2_name}"
                }
              }
            }
          }
        }
      }
    },
    "all_db" : {
      "children" : {
        "db" : {
          "children" : {
            "s4test_db" : {
              "hosts" : {
                "${var.vm_prefix}db11" : {
                  "gce_instance_labels" : {
                    "active_region" : true,
                    "component" : "db",
                    "component_type" : "db",
                    "environment" : "s4test",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "ha_sr_pcs_scenario" : "ON",
                    "hana_sr_failover_type" : "ILB",
                    "hana_sr_is_active_region" : true,
                    "hana_sr_remote_host" : "",
                    "hana_sr_tier" : 1,
                    "hana_sr_tier1_dns_target" : "sapddb-vip11.s4test.gcp.sapcloud.goog.",
                    "sid" : "HD1"
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
                    "environment" : "s4test",
                    "service_group" : "s4"
                  },
                  "gce_instance_metadata" : {
                    "active_region" : true,
                    "ha_sr_pcs_scenario" : "ON",
                    "hana_sr_failover_type" : "ILB",
                    "hana_sr_is_active_region" : true,
                    "hana_sr_remote_host" : "${var.vm_prefix}db11",
                    "hana_sr_tier" : 2,
                    "hana_sr_tier1_dns_target" : "sapddb-vip11.s4test.gcp.sapcloud.goog.",
                    "sid" : "HD1"
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
    },
    "s4" : {
      "children" : {
        "s4_s4test" : {
          "hosts" : {
            "${var.vm_prefix}app11" : {
              "gce_instance_labels" : {
                "active_region" : true,
                "component" : "app",
                "component_type" : "app",
                "environment" : "s4test",
                "service_group" : "s4"
              },
              "gce_instance_metadata" : {
                "active_region" : true,
                "sid" : "ED1"
              },
              "gce_instance_name" : "${var.vm_prefix}app11",
              "gce_instance_project" : "${data.google_project.sap-project.project_id}",
              "gce_instance_zone" : "${var.zone1_name}"
            },
            "${var.vm_prefix}ascs11" : {
              "gce_instance_labels" : {
                "active_region" : true,
                "component" : "ascs",
                "component_type" : "ascs",
                "environment" : "s4test",
                "service_group" : "s4"
              },
              "gce_instance_metadata" : {
                "active_region" : true,
                "sid" : "ED1"
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
                "environment" : "s4test",
                "service_group" : "s4"
              },
              "gce_instance_metadata" : {
                "active_region" : true,
                "sid" : "ED1"
              },
              "gce_instance_name" : "${var.vm_prefix}ascs12",
              "gce_instance_project" : "${data.google_project.sap-project.project_id}",
              "gce_instance_zone" : "${var.zone2_name}"
            },
            "${var.vm_prefix}db11" : {
              "gce_instance_labels" : {
                "active_region" : true,
                "component" : "db",
                "component_type" : "db",
                "environment" : "s4test",
                "service_group" : "s4"
              },
              "gce_instance_metadata" : {
                "active_region" : true,
                "ha_sr_pcs_scenario" : "ON",
                "hana_sr_failover_type" : "ILB",
                "hana_sr_is_active_region" : true,
                "hana_sr_remote_host" : "",
                "hana_sr_tier" : 1,
                "hana_sr_tier1_dns_target" : "sapddb-vip11.s4test.gcp.sapcloud.goog.",
                "sid" : "HD1"
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
                "environment" : "s4test",
                "service_group" : "s4"
              },
              "gce_instance_metadata" : {
                "active_region" : true,
                "ha_sr_pcs_scenario" : "ON",
                "hana_sr_failover_type" : "ILB",
                "hana_sr_is_active_region" : true,
                "hana_sr_remote_host" : "${var.vm_prefix}db11",
                "hana_sr_tier" : 2,
                "hana_sr_tier1_dns_target" : "sapddb-vip11.s4test.gcp.sapcloud.goog.",
                "sid" : "HD1"
              },
              "gce_instance_name" : "${var.vm_prefix}db12",
              "gce_instance_project" : "${data.google_project.sap-project.project_id}",
              "gce_instance_zone" : "${var.zone2_name}"
            }
          }
        }
      }
    }
  })
  name = "wlm.s4test.yml"
}
