/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  required_version = "~> 0.11.0"
}

resource "google_compute_disk" "gcp_sap_hana_sd_0" {
  name = "sap-hana-pd-sd-0"
  type = "pd-standard"
  zone = "${var.zone}"
  size = "${var.pd_standard_size}"
}

resource "google_compute_address" "gcp_sap_hana_ip" {
  name   = "gcp-sap-hana-ip"
  region = "${var.region}"
}

resource "google_compute_disk" "gcp_sap_hana_sd_1" {
  name = "sap-hana-pd-sd-1"
  type = "pd-standard"
  zone = "${var.zone}"
  size = "${var.pd_standard_size}"
}

resource "google_compute_instance" "gcp_sap_hana" {
  name         = "${var.instance_name}"
  machine_type = "${var.instance_type}"
  zone         = "${var.zone}"

  #tags           = "${var.network_tags}"
  can_ip_forward = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    auto_delete = "${var.autodelete_disk}"

    initialize_params {
      image = "projects/${var.linux_image_project}/global/images/family/${var.linux_image_family}"
      size  = "${var.boot_disk_size}"
      type  = "${var.boot_disk_type}"
    }
  }

  attached_disk {
    source = "${google_compute_disk.gcp_sap_hana_sd_0.self_link}"
  }

  attached_disk {
    source = "${google_compute_disk.gcp_sap_hana_sd_1.self_link}"
  }

  network_interface {
    subnetwork = "${var.subnetwork}"

    access_config {
      nat_ip = "${element(google_compute_address.gcp_sap_hana_ip.*.address, count.index)}"
    }
  }

  metadata {
    sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
    sap_deployment_debug       = "${var.sap_deployment_debug}"
    post_deployment_script     = "${var.post_deployment_script}"
    sap_hana_sid               = "${var.sap_hana_sid}"
    sap_hana_instance_number   = "${var.sap_hana_instance_number}"
    sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
    sap_hana_system_password   = "${var.sap_hana_system_password}"
    sap_hana_sidadm_uid        = "${var.sap_hana_sidadm_uid}"
    sap_hana_sapsys_gid        = "${var.sap_hana_sapsys_gid}"

    # Needed for startup-scripts module
    startup-script        = "${var.startup-script}"
    startup-script-custom = "${var.startup-script-custom}"
  }

  # Removed this argument since it cannot be used with the startup-script metadata key that's needed for startup-scripts module.
  #metadata_startup_script = "${file("${path.module}/files/startup.sh")}"

  service_account {
    email  = "${var.service_account}"
    scopes = ["cloud-platform"]
  }
}
