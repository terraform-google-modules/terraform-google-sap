


resource "google_compute_address" "alidascs11" {
  address_type = "INTERNAL"
  name         = "alidascs11"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = google_compute_instance.sapdascs11.network_interface[0].subnetwork
}


resource "google_compute_address" "aliders11" {
  address_type = "INTERNAL"
  name         = "aliders11"
  project      = data.google_project.sap-project.project_id
  region       = var.region_name
  subnetwork   = google_compute_instance.sapdascs12.network_interface[0].subnetwork
}


resource "google_compute_disk" "sapdascs11" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}ascs11"
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


resource "google_compute_disk" "sapdascs11-usr-sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}ascs11-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.ascs_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapdascs12" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}ascs12"
  project = data.google_project.sap-project.project_id
  size    = 50
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_disk" "sapdascs12-usr-sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}ascs12-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.ascs_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_instance" "sapdascs11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdascs11-usr-sap.name
    source      = google_compute_disk.sapdascs11-usr-sap.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdascs11.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.ascs_machine_type
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}ascs11"
  network_interface {
    access_config {
    }

    network = data.google_compute_network.sap-vpc.self_link
  }


  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service-account-sap-ascs-role-s4test.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-ascs"]
  zone = var.zone1_name
}


resource "google_compute_instance" "sapdascs12" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdascs12-usr-sap.name
    source      = google_compute_disk.sapdascs12-usr-sap.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdascs12.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.ascs_machine_type
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}ascs12"
  network_interface {
    access_config {
    }

    network = data.google_compute_network.sap-vpc.self_link
  }


  project = data.google_project.sap-project.project_id
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = google_service_account.service-account-sap-ascs-role-s4test.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-ascs"]
  zone = var.zone2_name
}


resource "google_dns_record_set" "alidascs11_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "alidascs11.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_address.alidascs11.address]
  ttl          = 300
  type         = "A"
}


resource "google_dns_record_set" "aliders11_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "aliders11.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_address.aliders11.address]
  ttl          = 300
  type         = "A"
}


resource "google_dns_record_set" "sapdascs11_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "${var.vm_prefix}ascs11.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}


resource "google_dns_record_set" "sapdascs12_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "${var.vm_prefix}ascs12.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdascs12.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_service_account" "service-account-sap-ascs-role-s4test" {
  account_id = "sap-ascs-role-s4test"
  project    = data.google_project.sap-project.project_id
}
