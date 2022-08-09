# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "development" { 
  name            = local.cluster_name
  location        = local.zone
  project         = local.project_name
  networking_mode = "VPC_NATIVE"
  network         = google_compute_network.rnd.self_link
  subnetwork      = google_compute_subnetwork.private.self_link

  remove_default_node_pool = true
  initial_node_count       = 1
  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${local.cluster_name}-pod-range"
    services_secondary_range_name = "${local.cluster_name}-services-range"
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.132.0.0/28"
  }
  vertical_pod_autoscaling {
    enabled = true
  }
}

resource "google_container_node_pool" "zonal-node" {
  name       = "${local.machine_type}-pool"
  location   = local.zone
  cluster    = google_container_cluster.development.name
  project    = local.project_name
  node_count = local.node_count
  autoscaling {
    min_node_count = local.node_count
    max_node_count = local.max_node_count
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = local.machine_type
    image_type   = "COS_CONTAINERD"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    
    # gke-default scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}