variable "cluster_name" {
  type = any
}

variable "cluster_location" {
  type = any
}

variable "project_id" {
  type = any
}
variable "project_region" {
  type = any
}

variable "node_locations" { type = any }
variable "addons_config" { type = any }
variable "cluster_ipv4_cidr" { type = any }
variable "cluster_autoscaling" { type = any }
variable "service_external_ips_config" { type = any }
variable "mesh_certificates" { type = any }
variable "database_encryption" { type = any }

variable "description" { type = any }
variable "default_max_pods_per_node" { type = any }
variable "enable_binary_authorization" { type = any }
variable "enable_kubernetes_alpha" { type = any }
variable "enable_tpu" { type = any }
variable "enable_legacy_abac" { type = any }
variable "enable_shielded_nodes" { type = any }
variable "enable_autopilot" { type = any }
variable "initial_node_count" { type = any }

variable "ip_allocation_policy" { type = any }
variable "networking_mode" { type = any }
variable "logging_config" { type = any }
variable "logging_service" { type = any }

variable "maintenance_policy" { type = any }

variable "master_auth" { type = any }
variable "master_authorized_networks_config" { type = any }
variable "min_master_version" { type = any }

variable "monitoring_config" { type = any }
variable "monitoring_service" { type = any }

variable "network" { type = any }
variable "node_config" { type = any }

variable "network_config" { type = any }
variable "network_policy" { type = any }
variable "node_pool" { type = any }
variable "node_pool_auto_config" { type = any }
variable "node_pool_defaults" { type = any }
variable "node_version" { type = any }

variable "notification_config" { type = any }
variable "confidential_nodes" { type = any }

variable "pod_security_policy_config" { type = any }
variable "authenticator_groups_config" { type = any }
variable "private_cluster_config" { type = any }
variable "cluster_telemetry" { type = any }

variable "project" { type = any }
variable "release_channel" { type = any }
variable "remove_default_node_pool" { type = any }
variable "resource_labels" { type = any }
variable "resource_usage_export_config" { type = any }
variable "subnetwork" { type = any }
variable "vertical_pod_autoscaling" { type = any }
variable "workload_identity_config" { type = any }

variable "enable_intranode_visibility" { type = any }
variable "enable_l4_ilb_subsetting" { type = any }
variable "private_ipv6_google_access" { type = any }
variable "datapath_provider" { type = any }

variable "default_snat_status" { type = any }
variable "dns_config" { type = any }






