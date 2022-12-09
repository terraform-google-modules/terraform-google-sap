


resource "google_compute_disk" "sapddb11" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}db11"
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


resource "google_compute_disk" "sapddb11-export-backup" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-export-backup"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_export_backup_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapddb11-hana-data" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-data"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_data_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapddb11-hana-log" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-log"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_log_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapddb11-hana-restore" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-restore"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_restore_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-standard"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapddb11-hana-shared" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-hana-shared"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_shared_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapddb11-usr-sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db11-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone1_name
}


resource "google_compute_disk" "sapddb12" {
  image = var.sap_boot_disk_image
  lifecycle {
    ignore_changes = [snapshot, image]
  }

  name    = "${var.vm_prefix}db12"
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


resource "google_compute_disk" "sapddb12-export-backup" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-export-backup"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_export_backup_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_disk" "sapddb12-hana-data" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-data"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_data_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_disk" "sapddb12-hana-log" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-log"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_log_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_disk" "sapddb12-hana-restore" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-restore"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_restore_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-standard"
  zone = var.zone2_name
}


resource "google_compute_disk" "sapddb12-hana-shared" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-hana-shared"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_hana_shared_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_disk" "sapddb12-usr-sap" {
  lifecycle {
    ignore_changes = [snapshot]
  }

  name    = "${var.vm_prefix}db12-usr-sap"
  project = data.google_project.sap-project.project_id
  size    = var.db_disk_usr_sap_size
  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }

  type = "pd-ssd"
  zone = var.zone2_name
}


resource "google_compute_forwarding_rule" "db-forwarding-rule" {
  all_ports             = true
  allow_global_access   = true
  backend_service       = google_compute_region_backend_service.db-service.self_link
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  name                  = "db-forwarding-rule"
  network               = data.google_compute_network.sap-vpc.self_link
  project               = data.google_project.sap-project.project_id
  region                = var.region_name
  subnetwork            = google_compute_instance.sapddb11.network_interface[0].subnetwork
}


resource "google_compute_health_check" "db-service-health-check" {
  check_interval_sec = 10
  name               = "db-service-health-check"
  project            = data.google_project.sap-project.project_id
  tcp_health_check {
    port = "60000"
  }

  timeout_sec = 10
}


resource "google_compute_instance" "sapddb11" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapddb11-usr-sap.name
    source      = google_compute_disk.sapddb11-usr-sap.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11-hana-data.name
    source      = google_compute_disk.sapddb11-hana-data.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11-hana-log.name
    source      = google_compute_disk.sapddb11-hana-log.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11-hana-shared.name
    source      = google_compute_disk.sapddb11-hana-shared.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11-export-backup.name
    source      = google_compute_disk.sapddb11-export-backup.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb11-hana-restore.name
    source      = google_compute_disk.sapddb11-hana-restore.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapddb11.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.db_machine_type
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}db11"
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
    email  = google_service_account.service-account-sap-db-role-s4test.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-db"]
  zone = var.zone1_name
}


resource "google_compute_instance" "sapddb12" {
  allow_stopping_for_update = var.allow_stopping_for_update
  attached_disk {
    device_name = google_compute_disk.sapddb12-usr-sap.name
    source      = google_compute_disk.sapddb12-usr-sap.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12-hana-data.name
    source      = google_compute_disk.sapddb12-hana-data.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12-hana-log.name
    source      = google_compute_disk.sapddb12-hana-log.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12-hana-shared.name
    source      = google_compute_disk.sapddb12-hana-shared.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12-export-backup.name
    source      = google_compute_disk.sapddb12-export-backup.self_link
  }

  attached_disk {
    device_name = google_compute_disk.sapddb12-hana-restore.name
    source      = google_compute_disk.sapddb12-hana-restore.self_link
  }


  boot_disk {
    auto_delete = false
    device_name = "persistent-disk-0"
    source      = google_compute_disk.sapddb12.self_link
  }

  lifecycle {
    ignore_changes = [
      min_cpu_platform,
      network_interface[0].alias_ip_range,
      metadata["ssh-keys"]
    ]
  }

  machine_type = var.db_machine_type
  metadata = {
    ssh-keys = ""
  }
  name = "${var.vm_prefix}db12"
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
    email  = google_service_account.service-account-sap-db-role-s4test.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["wlm-db"]
  zone = var.zone2_name
}


resource "google_compute_instance_group" "sapddb11-group" {
  description = "sapddb11-group"
  instances   = [google_compute_instance.sapddb11.self_link]
  name        = "sapddb11-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone1_name
}


resource "google_compute_instance_group" "sapddb12-group" {
  description = "sapddb12-group"
  instances   = [google_compute_instance.sapddb12.self_link]
  name        = "sapddb12-group"
  project     = data.google_project.sap-project.project_id
  zone        = var.zone2_name
}


resource "google_compute_region_backend_service" "db-service" {
  backend {
    group = google_compute_instance_group.sapddb11-group.self_link
  }

  backend {
    failover = true
    group    = google_compute_instance_group.sapddb12-group.self_link
  }


  description = "db-service"
  failover_policy {
    disable_connection_drain_on_failover = true
    drop_traffic_if_unhealthy            = true
    failover_ratio                       = 1
  }

  health_checks    = [google_compute_health_check.db-service-health-check.self_link]
  name             = "db-service"
  project          = data.google_project.sap-project.project_id
  protocol         = "TCP"
  region           = var.region_name
  session_affinity = "CLIENT_IP"
  timeout_sec      = 10
}


resource "google_dns_record_set" "db_s4test_gcp_sapcloud_goog_" {
  lifecycle {
    ignore_changes = [rrdatas]
  }

  managed_zone = google_dns_managed_zone.s4test.name
  name         = "db.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = ["sapddb-vip11.s4test.gcp.sapcloud.goog."]
  ttl          = 60
  type         = "CNAME"
}


resource "google_dns_record_set" "sapddb-vip11_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "sapddb-vip11.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_forwarding_rule.db-forwarding-rule.ip_address]
  ttl          = 300
  type         = "A"
}


resource "google_dns_record_set" "sapddb11_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "${var.vm_prefix}db11.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb11.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}


resource "google_dns_record_set" "sapddb12_s4test_gcp_sapcloud_goog_" {
  managed_zone = google_dns_managed_zone.s4test.name
  name         = "${var.vm_prefix}db12.s4test.gcp.sapcloud.goog."
  project      = data.google_project.sap-project.project_id
  rrdatas      = [google_compute_instance.sapddb12.network_interface.0.network_ip]
  ttl          = 300
  type         = "A"
}

resource "google_service_account" "service-account-sap-db-role-s4test" {
  account_id = "sap-db-role-s4test"
  project    = data.google_project.sap-project.project_id
}
