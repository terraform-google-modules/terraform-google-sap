data "google_compute_network" "sap-vpc" {
  name    = var.vpc_name
  project = data.google_project.sap-project.project_id
}
