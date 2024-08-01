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

data "google_compute_subnetwork" "sap-subnet-ansible-1" {
  name    = var.subnet_name
  project = data.google_compute_network.sap-vpc.project
  region  = var.region_name
}

data "google_service_account" "service_account_ansible" {
  account_id = var.ansible_sa_email == "" ? google_service_account.service_account_ansible[0].email : var.ansible_sa_email
}

resource "google_compute_address" "sapdansible11-1" {
  address_type = "INTERNAL"
  name         = "${var.deployment_name}-ansible-runner-internal"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = data.google_compute_subnetwork.sap-subnet-ansible-1.self_link
}

resource "google_compute_disk" "sapdansible11" {
  image = "projects/rhel-cloud/global/images/rhel-9-v20230615"
  lifecycle {
    ignore_changes = [snapshot, image]
  }
  name    = "${var.deployment_name}-ansible-runner"
  project = data.google_project.sap-project.project_id
  size    = 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = "pd-ssd"
  zone = var.zone1_name
}

resource "google_compute_instance" "sapdansible11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdansible11.self_link
  }
  depends_on = [
    google_storage_bucket_object.ansible_inventory,
    google_compute_instance.sapdapp11,
    google_compute_instance.sapdapp12,
    google_compute_instance.sapddb11,
    google_compute_instance.sapddb12,
    google_compute_instance.sapdascs11,
    google_compute_instance.sapdascs12
  ]
  labels = {
    active_region  = true
    component      = "ansible"
    component_type = "generic"
    environment    = var.deployment_name
    service_group  = "ansible_runner"
  }
  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }
  machine_type = "n1-standard-16"
  metadata = {
    active_region             = true
    ansible_sa_email          = data.google_service_account.service_account_ansible.email
    app_sa_email              = data.google_service_account.service_account_app.email
    ascs_sa_email             = data.google_service_account.service_account_ascs.email
    configuration_bucket_name = data.google_storage_bucket.configuration.name
    db_sa_email               = data.google_service_account.service_account_db.email
    dns_zone_name             = var.deployment_has_dns ? data.google_dns_managed_zone.sap_zone[0].name : ""
    is_test                   = var.is_test
    media_bucket_name         = var.media_bucket_name
    ssh-keys                  = ""
    startup-script            = "gsutil cp ${var.primary_startup_url} ./local_startup.sh; bash local_startup.sh ${var.package_location} ${var.deployment_name}"
    template_name             = "s4_ha"
  }
  name = "${var.deployment_name}-ansible-runner"
  network_interface {
    dynamic "access_config" {
      content {
      }
      for_each = var.public_ansible_runner_ip ? [1] : []
    }
    network    = data.google_compute_network.sap-vpc.self_link
    network_ip = google_compute_address.sapdansible11-1.address
    subnetwork = data.google_compute_subnetwork.sap-subnet-ansible-1.self_link
  }
  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }
  service_account {
    email  = data.google_service_account.service_account_ansible.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  tags = compact(concat(["${var.deployment_name}-s4-comms"], var.custom_tags))
  zone = var.zone1_name
}

resource "google_project_iam_member" "ansible_sa_role_1" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.instanceAdmin.v1"
}

resource "google_project_iam_member" "ansible_sa_role_10" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/iam.roleViewer"
}

resource "google_project_iam_member" "ansible_sa_role_11" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/workloadmanager.insightWriter"
}

resource "google_project_iam_member" "ansible_sa_role_2" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/storage.objectViewer"
}

resource "google_project_iam_member" "ansible_sa_role_3" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/dns.admin"
}

resource "google_project_iam_member" "ansible_sa_role_4" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/logging.admin"
}

resource "google_project_iam_member" "ansible_sa_role_5" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/iam.serviceAccountUser"
}

resource "google_project_iam_member" "ansible_sa_role_6" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/secretmanager.viewer"
}

resource "google_project_iam_member" "ansible_sa_role_7" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/secretmanager.secretAccessor"
}

resource "google_project_iam_member" "ansible_sa_role_8" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/monitoring.admin"
}

resource "google_project_iam_member" "ansible_sa_role_9" {
  count   = var.ansible_sa_email == "" ? 1 : 0
  member  = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  project = data.google_project.sap-project.project_id
  role    = "roles/compute.viewer"
}

resource "google_service_account" "service_account_ansible" {
  account_id = "${var.deployment_name}-ansible"
  count      = var.ansible_sa_email == "" ? 1 : 0
  project    = data.google_project.sap-project.project_id
}

resource "google_service_account_iam_member" "ansible_sa_user_of_app" {
  count              = var.ansible_sa_email == "" ? 1 : 0
  member             = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = data.google_service_account.service_account_app.name
}

resource "google_service_account_iam_member" "ansible_sa_user_of_ascs" {
  count              = var.ansible_sa_email == "" ? 1 : 0
  member             = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = data.google_service_account.service_account_ascs.name
}

resource "google_service_account_iam_member" "ansible_sa_user_of_db" {
  count              = var.ansible_sa_email == "" ? 1 : 0
  member             = "serviceAccount:${data.google_service_account.service_account_ansible.email}"
  role               = "roles/iam.serviceAccountUser"
  service_account_id = data.google_service_account.service_account_db.name
}
