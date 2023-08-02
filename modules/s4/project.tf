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

data "google_project" "sap-project" {
  project_id = var.gcp_project_id
}

locals {
  cpu_platform_map = {
    m1-megamem-96  = "Intel Skylake"
    n1-highmem-16  = "Intel Broadwell"
    n1-highmem-32  = "Intel Broadwell"
    n1-highmem-64  = "Intel Broadwell"
    n1-highmem-8   = "Intel Broadwell"
    n1-highmem-96  = "Intel Skylake"
    n1-megamem-96  = "Intel Skylake"
    n1-standard-16 = "Intel Broadwell"
    n1-standard-32 = "Intel Broadwell"
    n1-standard-64 = "Intel Broadwell"
    n1-standard-8  = "Intel Broadwell"
    n1-standard-96 = "Intel Skylake"
  }
}

provider "google" {
  project = "!!! Terraform resource is using default project name !!!"
  region  = "!!! Terraform resource is using default region !!!"
}

resource "google_compute_firewall" "intra_vm_communication" {
  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  description = "Enables intra VM communications"
  name        = "${var.deployment_name}-communication-firewall"
  network     = data.google_compute_network.sap-vpc.self_link
  project     = data.google_project.sap-project.project_id
  source_tags = ["${var.deployment_name}-s4-comms"]
  target_tags = ["${var.deployment_name}-s4-comms"]
}

resource "google_dns_managed_zone" "sap_zone" {
  depends_on    = [google_project_service.service_dns_googleapis_com]
  description   = "${var.deployment_name} SAP DNS zone"
  dns_name      = "${var.deployment_name}.${var.dns_zone_name_suffix}"
  force_destroy = true
  name          = "${var.deployment_name}"
  private_visibility_config {
    networks {
      network_url = data.google_compute_network.sap-vpc.self_link
    }

  }

  project    = data.google_project.sap-project.project_id
  visibility = "private"
}

resource "google_dns_record_set" "sap_fstore_1" {
  managed_zone = google_dns_managed_zone.sap_zone.name
  name         = "fstore-${var.deployment_name}-1.${var.deployment_name}.${var.dns_zone_name_suffix}"
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_filestore_instance.sap_fstore_1.networks[0].ip_addresses[0]]
  ttl          = 60
  type         = "A"
}

resource "google_filestore_instance" "sap_fstore_1" {
  depends_on = [google_project_service.service_file_googleapis_com]
  file_shares {
    capacity_gb = var.filestore_gb
    name        = "default"
  }

  location = var.filestore_location == "" ? var.region_name : var.filestore_location
  name     = "fstore-${var.deployment_name}-1"
  networks {
    modes   = ["MODE_IPV4"]
    network = data.google_compute_network.sap-vpc.name
  }

  project = data.google_project.sap-project.project_id
  tier    = var.filestore_tier
}
