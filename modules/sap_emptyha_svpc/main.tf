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
  required_version = "~> 0.12.3"
}


data "template_file" "startup_sap_emptyha_hana_1" {
  template = "${file("${path.module}/files/startup.sh")}"
}

data "template_file" "startup_sap_emptyha_hana_2" {
  template = "${file("${path.module}/files/startup_secondary.sh")}"
}


data "google_compute_subnetwork" "subnet" {
  name    = "${var.subnetwork}"
  project = "${var.subnetwork_project}"
  region  = "${var.region}"
}

resource "google_compute_address" "primary_instance_ip" {
  project      = "${var.project_id}"
  name         = "${var.primary_instance_ip}"
  address_type = "INTERNAL"
  region       = "${var.region}"
  subnetwork   = "projects/${var.subnetwork_project}/regions/${var.region}/subnetworks/${var.subnetwork}"
}

resource "google_compute_address" "secondary_instance_ip" {
  project      = "${var.project_id}"
  name         = "${var.secondary_instance_ip}"
  address_type = "INTERNAL"
  region       = "${var.region}"
  subnetwork   = "projects/${var.subnetwork_project}/regions/${var.region}/subnetworks/${var.subnetwork}"
}

resource "google_compute_address" "internal" {
  project      = "${var.project_id}"
  name         = "${var.sap_vip_internal_address}"
  subnetwork   = "${data.google_compute_subnetwork.subnet.self_link}"
  address_type = "INTERNAL"
  address      = "${var.sap_vip}"
  region       = "${var.region}"
}

resource "google_compute_instance" "primary" {
  project        = "${var.project_id}"
  name           = "${var.primary_instance_name}"
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
    device_name = "${var.device_0}"

    initialize_params {
      image = "projects/${var.linux_image_project}/global/images/family/${var.linux_image_family}"
      size  = "${var.boot_disk_size}"
      type  = "${var.boot_disk_type}"
    }
  }


  network_interface {
    network_ip         = "${google_compute_address.primary_instance_ip.address}"
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.subnetwork_project}"
    dynamic "access_config" {
      for_each = [for i in [""] : i if var.public_ip]
      content {}
    }
  }

  metadata = {
    sap_deployment_debug    = "${var.sap_deployment_debug}"
    post_deployment_script  = "${var.post_deployment_script}"
    sap_primary_instance    = "${var.primary_instance_name}"
    sap_secondary_instance  = "${var.secondary_instance_name}"
    sap_primary_zone        = "${var.primary_zone}"
    sap_secondary_zone      = "${var.secondary_zone}"
    sap_vip                 = "${var.sap_vip}"
    sap_vip_secondary_range = "${var.sap_vip_secondary_range}"
    publicIP                = "${var.public_ip}"
    startup-script          = "${data.template_file.startup_sap_emptyha_hana_1.rendered}"
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "secondary" {
  project        = "${var.project_id}"
  name           = "${var.secondary_instance_name}"
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
    device_name = "${var.device_0}"

    initialize_params {
      image = "projects/${var.linux_image_project}/global/images/family/${var.linux_image_family}"
      size  = "${var.boot_disk_size}"
      type  = "${var.boot_disk_type}"
    }
  }

  network_interface {
    network_ip         = "${google_compute_address.secondary_instance_ip.address}"
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.subnetwork_project}"

    dynamic "access_config" {
      for_each = [for i in [""] : i if var.public_ip]
      content {}
    }
  }

  metadata = {
    sap_deployment_debug    = "${var.sap_deployment_debug}"
    post_deployment_script  = "${var.post_deployment_script}"
    sap_primary_instance    = "${var.primary_instance_name}"
    sap_secondary_instance  = "${var.secondary_instance_name}"
    sap_primary_zone        = "${var.primary_zone}"
    sap_secondary_zone      = "${var.secondary_zone}"
    sap_vip                 = "${var.sap_vip}"
    sap_vip_secondary_range = "${var.sap_vip_secondary_range}"
    publicIP                = "${var.public_ip}"
    startup-script          = "${data.template_file.startup_sap_emptyha_hana_2.rendered}"
  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}
