data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  location = var.cluster_location
}

output "endpoint" {
  value = data.google_container_cluster.my_cluster.endpoint
}

output "instance_group_urls" {
  value = data.google_container_cluster.my_cluster.node_pool[0].instance_group_urls
}

output "node_config" {
  value = data.google_container_cluster.my_cluster.node_config
}

output "node_pools" {
  value = data.google_container_cluster.my_cluster.node_pool
}