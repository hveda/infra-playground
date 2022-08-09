# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "rnd" {
  name                    = "${local.cluster_name}-network"
  project                 = local.project_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1500
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = "${local.cluster_name}-subnetwork"
  project                  = local.project_name
  ip_cidr_range            = "10.1.0.0/20"
  region                   = local.region
  network                  = google_compute_network.rnd.self_link
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = local.secondary_ip_ranges

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}