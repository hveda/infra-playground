locals {
  region               = "asia-southeast1"
  zone                 = "asia-southeast1-c"
  project_name         = "rnd-heridotlife"
  projects_api         = "container.googleapis.com"
  initial_node_count   = 1
  cluster_name         = "development-cluster"
  machine_type         = "n1-standard-2"
  max_node_count       = 1
  network              = "projects/emtrade-v2/global/networks/staging-cluster-network"
  node_count           = 1
  secondary_ip_ranges  = {
    "${local.cluster_name}-pod-range"      = "10.4.0.0/14",
    "${local.cluster_name}-services-range" = "10.8.0.0/19"
  }
}
