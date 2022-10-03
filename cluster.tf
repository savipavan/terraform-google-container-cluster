resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location
  node_locations = var.node_locations

  dynamic "addons_config" {
    for_each = try(var.addons_config, null) != null ? var.addons_config : []
    content {
      horizontal_pod_autoscaling = try(addons_config.value.horizontal_pod_autoscaling, null)
      http_load_balancing = try(addons_config.value.http_load_balancing, null)
      network_policy_config = try(addons_config.value.network_policy_config, null)
      gcp_filestore_csi_driver_config = try(addons_config.value.gcp_filestore_csi_driver_config, null)
      
      dynamic "cloudrun_config" {
        for_each = try(addons_config.value.cloudrun_config, null) != null ? [addons_config.value.cloudrun_config] : []
        content {
          disabled = try(cloudrun_config.value.disabled, null)
          load_balancer_type = try(cloudrun_config.value.load_balancer_type, null)
        }
      }

      dynamic "istio_config" {
        for_each = try(addons_config.value.istio_config, null) != null ? [addons_config.value.istio_config] : []
        content {
          disabled = try(istio_config.value.disabled, null)
          auth = try(istio_config.value.auth, null)
        }
      }

      dynamic "identity_service_config" {
        for_each = try(addons_config.value.identity_service_config, null) != null ? [addons_config.value.identity_service_config] : []
        content {
          enabled = try(identity_service_config.value.enabled, null)
        }
      }

      dns_cache_config = var.dns_cache_config
      gce_persistent_disk_csi_driver_config = var.gce_persistent_disk_csi_driver_config
      kalm_config = var.kalm_config
      config_connector_config = var.config_connector_config
      gke_backup_agent_config = var.gke_backup_agent_config
    }  
  }

  cluster_ipv4_cidr = var.cluster_ipv4_cidr

  dynamic "cluster_autoscaling" {
    for_each = try(var.cluster_autoscaling, null) != null ? var.cluster_autoscaling : []
    content {
      enabled = try(var.cluster_autoscaling.value.enabled, null)
      
      dynamic "resource_limits" {
        for_each try(cluster_autoscaling.value.resource_limits, null) != null ? [cluster_autoscaling.value.resource_limits] : []
        content {
          resource_type = try(resource_limits.value.resource_type, null)
          minimum = try(resource_limits.value.minimum, null)
          maximum = try(resource_limits.value.maximum, null)
        }
      }

      dynamic "auto_provisioning_defaults" {
        for_each = try(cluster_autoscaling.value.resource_limits, null) != null ? [cluster_autoscaling.value.resource_limits] : []
        content {
          min_cpu_platform = try(resource_limits.value.min_cpu_platform, null)
          oauth_scopes = try(resource_limits.value.oauth_scopes, null)
          service_account = try(resource_limits.value.service_account, null)
          boot_disk_kms_key = try(resource_limits.value.boot_disk_kms_key, null)
          image_type = try(resource.value.image_type, null)
        }
      }
    }
  }

  dynamic "service_external_ips_config" {
    for_each = try(var.service_external_ips_config, null) != null ? [var.service_external_ips_config] : []
    content {
      enabled = try(service_external_ips_config.value.enabled, null)
    }
  }

  dynamic "mesh_certificates" {
    for_each = try(var.mesh_certificates, null) != null ? [var.mesh_certificates] : []
    content {
      enable_certificates = try(mesh_certificates.value.enable_certificates, null)
    }
  }

  dynamic "database_encryption" {
    for_each = try(var.database_encryption, null) != null ? [var.database_encryption] : []
    content {
      state = try(database_encryption.value.state, null)
      key_name = try(database_encryption.value.key_name, null)
    }
  }
  
  description = var.description
  default_max_pods_per_node = var.default_max_pods_per_node
  enable_binary_authorization = var.enable_binary_authorization
  enable_kubernetes_alpha = var.enable_kubernetes_alpha
  enable_tpu = var.enable_tpu
  enable_legacy_abac = var.enable_legacy_abac
  enable_shielded_nodes = var.enable_shielded_nodes
  enable_autopilot = var.enable_autopilot
  initial_node_count = var.initial_node_count

  dynamic "ip_allocation_policy" {
    for_each = try(var.ip_allocation_policy, null) != null ? [var.ip_allocation_policy] : []
    content {
      cluster_secondary_range_name = try(ip_allocation_policy.value.cluster_secondary_range_name, null)
      services_secondary_range_name = try(ip_allocation_policy.value.services_secondary_range_name, null)
      cluster_ipv4_cidr_block = try(ip_allocation_policy.value.cluster_ipv4_cidr_block, null)
      services_ipv4_cidr_block = try(ip_allocation_policy.value.services_ipv4_cidr_block, null)
    }
  }

  networking_mode = var.networking_mode

  dynamic "logging_config" {
    for_each = try(var.logging_config, null) != null ? [var.logging_config] : []
    content {
      enable_components = try(logging_config.value.enable_components, null)
    }
  }

  logging_service = var.logging_service

  dynamic "maintenance_policy" {
    for_each = try(var.maintenance_policy, null) != null ? [var.maintenance_policy] : []
    content {
      daily_maintenance_window = try(maintenance_policy.value.daily_maintenance_window, null)
      recurring_window = try(maintenance_policy.value.recurring_window, null)
      maintenance_exclusion = try(maintenance_policy.value.maintenance_exclusion, null)
    }
  }
  
  dynamic "master_auth" {
    for_each = try(var.master_auth, null) != null ? [var.master_auth] : []
    content {
      client_certificate_config = try(master_auth.value.client_certificate_config, null)
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = try(var.master_authorized_networks_config, null) != null ? [var.master_authorized_networks_config] : []
    content {
      cidr_blocks = try(master_authorized_networks_config.value.cidr_blocks, null)
    }
  }

  min_master_version = var.min_master_version

  dynamic "monitoring_config" {
    for_each = try(var.monitoring_config, null) != null ? [var.monitoring_config] : []
    content {
      enable_components = try(monitoring_config.value.enable_components, null)

      dynamic "managed_prometheus" {
        for_each = try(monitoring_config.value.managed_prometheus, null) != null ? [monitoring_config.value.managed_prometheus] : []
        content {
          enabled = try(managed_prometheus.value.enabled, null)
        }
      }
    }
  }

  monitoring_service = var.monitoring_service
  network = var.network

  dynamic "network_policy" {
    for_each = try(var.network_policy, null) != null ? [var.network_policy] : []
    content {
      provider = try(network_policy.value.provider, null)
      enabled = try(network_policy.value.enabled, null)
    }
  }

  dynamic "node_config" {
    for_each = try(var.node_config, null) != null ? [var.node_config] : []
    content {
      disk_size_gb = try(node_config.value.disk_size_gb, null)
      disk_type = try(node_config.value.disk_type, null)

      dynamic "ephemeral_storage_config" {
        for_each = try(node_config.value.ephemeral_storage_config, null) != null ? [node_config.value.ephemeral_storage_config] : []
        content {
          local_ssd_count = try(ephemeral_storage_config.value.local_ssd_count, null)
        }
      }

      dynamic "gcfs_config" {
        for_each = try(node_config.value.gcfs_config, null) != null ? [node_config.value.gcfs_config] : []
        content {
          enabled = try(gcfs_config.value.enabled, null)
        }
      }

      dynamic "gvnic" {
        for_each = try(node_config.value.gvnic, null) != null ? [node_config.value.gvnic] : []
        content {
          enabled = try(gvnic.value.enabled, null)
        }
      }

      dynamic "guest_accelerator" {
        for_each = try(node_config.value.uest_accelerator, null) != null ? [node_config.value.uest_accelerator] : []
        content {
          type = try(guest_accelerator.value.type, null)
          count = try(guest_accelerator.value.count, null)
          gpu_partition_size = try(guest_accelerator.value.gpu_partition_size, null)
        }
      }

      image_type = var.image_type
      labels = var.labels
      local_ssd_count = var.local_ssd_count
      machine_type = var.machine_type
      metadata = var.metadata
      min_cpu_platform = var.min_cpu_platform
      oauth_scopes = var.oauth_scopes
      preemptible = var.preemptible
      
    }
  }
  remove_default_node_pool = true
}