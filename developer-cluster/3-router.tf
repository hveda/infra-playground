# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router" {
  name    = "${local.cluster_name}-router"
  region  = local.region
  project = local.project_name
  network = google_compute_network.rnd.self_link

  bgp {
    asn = 64514
  }
}
