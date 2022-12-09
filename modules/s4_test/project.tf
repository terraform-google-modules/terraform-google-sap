

data "google_project" "sap-project" {
  project_id = "core-connect-dev"
}

provider "google" {
  project = "!!! Terraform resource is using default project name !!!"
  region  = "!!! Terraform resource is using default region !!!"
}


resource "google_dns_managed_zone" "s4test" {
  depends_on  = [google_project_service.service_dns_googleapis_com]
  description = "s4test SAP DNS zone"
  dns_name    = "s4test.gcp.sapcloud.goog."
  name        = "s4test"
  private_visibility_config {
    networks {
      network_url = data.google_compute_network.sap-vpc.self_link
    }

  }

  project    = data.google_project.sap-project.project_id
  visibility = "private"
}


resource "google_dns_record_set" "sap-fstore-1" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "fstore-s4test-1.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_filestore_instance.sap-fstore-1.networks[0].ip_addresses[0]]
  ttl          = 60
  type         = "A"
}

resource "google_filestore_instance" "sap-fstore-1" {
  file_shares {
    capacity_gb = 1024
    name        = "default"
  }

  location = var.region_name
  name     = "fstore-s4test-1"
  networks {
    modes   = ["MODE_IPV4"]
    network = data.google_compute_network.sap-vpc.name
  }

  project  = data.google_project.sap-project.project_id
  provider = google-beta
  tier     = "ENTERPRISE"
}
