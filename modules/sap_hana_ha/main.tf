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

resource "google_compute_address" "gcp_primary_instance_ip" {
  project = "${var.project_id}"
  name    = "${var.gcp_primary_instance_ip}"
  region  = "${var.region}"
}

resource "google_compute_address" "gcp_secondary_instance_ip" {
  project = "${var.project_id}"
  name    = "${var.gcp_secondary_instance_ip}"
  region  = "${var.region}"
}

resource "google_compute_address" "internal_sap_vip" {
  project      = "${var.project_id}"
  name         = "${var.sap_vip_internal_address}"
  subnetwork   = "${var.subnetwork}"
  address_type = "INTERNAL"
  address      = "${var.sap_vip}"
  region       = "us-central1"
}

resource "google_compute_disk" "pd_ssd_primary" {
  project = "${var.project_id}"
  name    = "pd-ssd-disk-primary"
  type    = "pd-ssd"
  zone    = "${var.primary_zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_standard_primary" {
  project = "${var.project_id}"
  name    = "pd-standard-disk-primary"
  type    = "pd-standard"
  zone    = "${var.primary_zone}"
  size    = "${var.pd_standard_size}"
}

resource "google_compute_disk" "pd_ssd_secondary" {
  project = "${var.project_id}"
  name    = "pd-ssd-disk-secondary"
  type    = "pd-ssd"
  zone    = "${var.secondary_zone}"
  size    = "${var.pd_ssd_size}"
}

resource "google_compute_disk" "pd_standard_secondary" {
  project = "${var.project_id}"
  name    = "pd-standard-disk-secondary"
  type    = "pd-standard"
  zone    = "${var.secondary_zone}"
  size    = "${var.pd_standard_size}"
}

resource "google_compute_instance" "primary" {
  project        = "${var.project_id}"
  name           = "${var.primary_instance}"
  machine_type   = "${var.instance_type}"
  zone           = "${var.primary_zone}"
  tags           = "${var.network_tags}"
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
    source = "${google_compute_disk.pd_ssd_primary.self_link}"
  }

  attached_disk {
    source = "${google_compute_disk.pd_standard_primary.self_link}"
  }

  network_interface {
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.project_id}"

    access_config {
      nat_ip = "${google_compute_address.gcp_primary_instance_ip.address}"
    }
  }

  metadata {
    sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
    sap_deployment_debug       = "${var.sap_deployment_debug}"
    post_deployment_script     = "${var.post_deployment_script}"
    sap_hana_sid               = "${var.sap_hana_sid}"
    primary_instance           = "${var.primary_instance}"
    secondary_instance         = "${var.secondary_instance}"
    primary_zone               = "${var.primary_zone}"
    secondary_zone             = "${var.secondary_zone}"
    sap_hana_instance_number   = "${var.sap_hana_instance_number}"
    sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
    sap_hana_system_password   = "${var.sap_hana_system_password}"
    sap_hana_sidadm_uid        = "${var.sap_hana_sidadm_uid}"
    sap_hana_sapsys_gid        = "${var.sap_hana_sapsys_gid}"
    sap_vip                    = "${var.sap_vip}"
    sap_vip_secondary_range    = "${var.sap_vip_secondary_range}"

    # Needed for startup-scripts module
    startup-script = "${var.startup_script_1}"
  }

  service_account {
    email  = "${var.service_account}"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "secondary" {
  project        = "${var.project_id}"
  name           = "${var.secondary_instance}"
  machine_type   = "${var.instance_type}"
  zone           = "${var.secondary_zone}"
  tags           = "${var.network_tags}"
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
    source = "${google_compute_disk.pd_ssd_secondary.self_link}"
  }

  attached_disk {
    source = "${google_compute_disk.pd_standard_secondary.self_link}"
  }

  network_interface {
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.project_id}"

    access_config {
      nat_ip = "${google_compute_address.gcp_secondary_instance_ip.address}"
    }
  }

  metadata {
    sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
    sap_deployment_debug       = "${var.sap_deployment_debug}"
    post_deployment_script     = "${var.post_deployment_script}"
    sap_hana_sid               = "${var.sap_hana_sid}"
    primary_instance           = "${var.primary_instance}"
    secondary_instance         = "${var.secondary_instance}"
    primary_zone               = "${var.primary_zone}"
    secondary_zone             = "${var.secondary_zone}"
    sap_hana_instance_number   = "${var.sap_hana_instance_number}"
    sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
    sap_hana_system_password   = "${var.sap_hana_system_password}"
    sap_hana_sidadm_uid        = "${var.sap_hana_sidadm_uid}"
    sap_hana_sapsys_gid        = "${var.sap_hana_sapsys_gid}"
    sap_vip                    = "${var.sap_vip}"
    sap_vip_secondary_range    = "${var.sap_vip_secondary_range}"

    # Needed for startup-scripts module
    startup-script = "${var.startup_script_2}"
  }

  service_account {
    email  = "${var.service_account}"
    scopes = ["cloud-platform"]
  }
}
