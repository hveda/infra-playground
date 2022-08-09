resource "google_compute_router_nat" "mist_nat" {
  name                               = "${local.cluster_name}-nat"
  project                            = local.project_name
  router                             = google_compute_router.router.name
  region                             = local.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  min_ports_per_vm                    = 64

  depends_on = [google_compute_subnetwork.private]
  log_config {
          enable = false
          filter = "ALL"
        }
}
