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


module "sap_hana" {
  source        = "./sap_hana_python"
  instance-type = "${var.instance_type}"
}

data "template_file" "startup_sap_hana" {
  template = "${file("${path.module}/files/startup.sh")}"
}

data "google_compute_subnetwork" "subnet" {
  name    = "${var.subnetwork}"
  project = "${var.subnetwork_project}"
  region  = "${var.region}"
}

resource "google_compute_disk" "gcp_sap_hana_sd_0" {
  project = "${var.project_id}"
  name    = "${var.disk_name_0}-${var.device_name_pd_ssd}"
  type    = "${var.disk_type_0}"
  zone    = "${var.zone}"
  size    = "${var.pd_ssd_size != "" ? var.pd_ssd_size : module.sap_hana.diskSize}"
}

resource "google_compute_disk" "gcp_sap_hana_sd_1" {
  project = "${var.project_id}"
  name    = "${var.disk_name_1}-${var.device_name_pd_hdd}"
  type    = "${var.disk_type_1}"
  zone    = "${var.zone}"
  size    = "${var.pd_hdd_size != "" ? var.pd_hdd_size : module.sap_hana.diskSize}"
}

# Create a VM which hosts a web page stating its identity ("VM")
resource "google_compute_instance" "gcp_service_project_vm" {
  name         = "${var.instance_name}"
  project      = "${var.project_id}"
  machine_type = "${var.instance_type}"
  zone         = "${var.zone}"
  tags         = "${var.network_tags}"

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


  metadata = {
    sap_hana_deployment_bucket = "${var.sap_hana_deployment_bucket}"
    sap_deployment_debug       = "${var.sap_deployment_debug}"
    post_deployment_script     = "${var.post_deployment_script}"
    sap_hana_sid               = "${var.sap_hana_sid}"
    sap_hana_instance_number   = "${var.sap_hana_instance_number}"
    sap_hana_sidadm_password   = "${var.sap_hana_sidadm_password}"
    sap_hana_system_password   = "${var.sap_hana_system_password}"
    sap_hana_sidadm_uid        = "${var.sap_hana_sidadm_uid}"
    sap_hana_sapsys_gid        = "${var.sap_hana_sapsys_gid}"
    publicIP                   = "${var.public_ip}"
    startup-script             = "${data.template_file.startup_sap_hana.rendered}"

  }

  network_interface {
    subnetwork         = "${var.subnetwork}"
    subnetwork_project = "${var.subnetwork_project}"

    dynamic "access_config" {
      for_each = [for i in [""] : i if var.public_ip]
      content {}
    }

  }

  service_account {
    email  = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}
