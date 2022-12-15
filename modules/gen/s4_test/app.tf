


resource "google_compute_disk" "sapdapp11" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}app11"
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


resource "google_compute_disk" "sapdapp11-export-interfaces" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}app11-export-interfaces"
  project = data.google_project.sap-project.project_id
  size    = var.app_disk_export_interfaces_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapdapp11-usr-sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}app11-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.app_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_instance" "sapdapp11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapdapp11-usr-sap.name
    source      = google_compute_disk.sapdapp11-usr-sap.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapdapp11-export-interfaces.name
    source      = google_compute_disk.sapdapp11-export-interfaces.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapdapp11.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.app_machine_type
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}app11"
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
    email  = google_service_account.service-account-sap-app-role-s4test.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-app"]
  zone = var.zone1_name
}


resource "google_dns_record_set" "sapdapp11_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "${var.vm_prefix}app11.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapdapp11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_service_account" "service-account-sap-app-role-s4test" {
  account_id = "sap-app-role-s4test"
  project    = data.google_project.sap-project.project_id
}
