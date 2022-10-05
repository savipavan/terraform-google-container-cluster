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

      dns_cache_config = try(addons_config.value.dns_cache_config, null)
      gce_persistent_disk_csi_driver_config = try(addons_config.value.gce_persistent_disk_csi_driver_config, null)
      kalm_config = try(addons_config.value.kalm_config, null)
      config_connector_config = try(addons_config.value.config_connector_config, null)
      gke_backup_agent_config = try(addons_config.value.gke_backup_agent_config, null)
    }  
  }

  cluster_ipv4_cidr = var.cluster_ipv4_cidr

  dynamic "cluster_autoscaling" {
    for_each = try(var.cluster_autoscaling, null) != null ? var.cluster_autoscaling : []
    content {
      enabled = try(var.cluster_autoscaling.value.enabled, null)
      
      dynamic "resource_limits" {
        for_each = try(cluster_autoscaling.value.resource_limits, null) != null ? [cluster_autoscaling.value.resource_limits] : []
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

      autoscaling_profile = try(cluster_autoscaling.value.autoscaling_profile, null)
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
      
      spot = var.spot
      
      dynamic "sandbox_config" {
        for_each = try(node_config.value.sandbox_config, null) != null ? [node_config.value.sandbox_config] : []
        content {

          dynamic "sandbox_type" {
            for_each = try(sandbox_config.value.sandbox_type, null) != null ? [sandbox_config.value.sandbox_type] : []
            content {
              gvisor = try(sandbox_type.value.sandbox_type, null)
            }
          }
        }
      }

      boot_disk_kms_key = var.boot_disk_kms_key
      service_account = var.service_account
      
      dynamic "shielded_instance_config" {
        for_each = try(node_config.value.shielded_instance_config, null) != null ? [node_config.value.shielded_instance_config] : []
        content {
          enable_secure_boot = try(shielded_instance_config.value.enable_secure_boot, null)
          enable_integrity_monitoring = try(shielded_instance_config.value.enable_integrity_monitoring, null)
        }
      }

      tags = var.tags

      dynamic "taint" {
        for_each = try(node_config.value.taint, null) != null ? [node_config.value.taint] : []
        content {
          key = try(taint.value.key, null)
          value = try(taint.value.value, null)
          effect = try(taint.value.effect, null)
        }
      }

      dynamic "workload_metadata_config" {
        for_each = try(node_config.valu.workload_metadata_config, null) != null ? [node_config.valu.workload_metadata_config] : []
        content {
          mode = try(workload_metadata_config.value.workload_metadata_config, null)
        }
      }

      dynamic "kubelet_config" {
        for_each = try(node_config.valu.workload_metadata_config, null) != null ? [node_config.valu.workload_metadata_config] : []
        content {
          cpu_manager_policy = try(kubelet_config.value.cpu_manager_policy, null)
          cpu_cfs_quota = try(kubelet_config.value.cpu_cfs_quota)
          cpu_cfs_quota_period = try(kubelet_config.value.cpu_cfs_quota_period)
        }
      }

      dynamic "linux_node_config" {
        for_each = try(node_config.value.linux_node_config, null) != null ? [node_config.value.linux_node_config] : []
        content {
          sysctls = try(linux_node_config.value.sysctls)
        }
      }

      node_group = var.node_group
    }
  }

  dynamic "network_config" {
    for_each = try(var.network_config, null) != null ? [var.network_config] : []
    content {
      create_pod_range = try(network_config.value.create_pod_range, null)
      pod_ipv4_cidr_block = try(network_config.value.pod_ipv4_cidr_block, null)
      pod_range = try(network_config.value.pod_range, null)
    }
  }

  node_pool = var.node_pool

  dynamic "node_pool_auto_config" {
    for_each = try(var.node_pool_auto_config, null) != null ? [var.node_pool_auto_config] : []
    content {
      network_tags = try(node_pool_auto_config.value.network_tags, null)
    }
  }

  dynamic "node_pool_defaults" {
    for_each = try(var.node_pool_defaults, null) != null ? [var.node_pool_defaults] : []
    content {
      node_config_defaults = try(node_pool_defaults.value.node_config_defaults)
    }
  }

  node_version = var.node_version

  dynamic "notification_config" {
    for_each = try(var.notification_config, null) != null ? [var.notification_config] : []
    content {
      
      dynamic "pubsub" {
        for_each = try(notification_config.value.pubsub, null) != null ? [notification_config.value.pubsub] : []
        content {
          enabled = try(pubsub.value.enabled, null)
          topic = try(pubsub.value.topic, null)
          filter = try(pubsub.value.filter, null)
        }
      }
    }
  }

  dynamic "confidential_nodes" {
    for_each = try(var.confidential_nodes, null) != null ? [var.confidential_nodes] : []
    content {
      enabled = try(confidential_nodes.value.enabled, null)
    }
  }

  dynamic "pod_security_policy_config" {
    for_each = try(var.pod_security_policy_config, null) != null ? [var.pod_security_policy_config] : []
    content {
      enabled = try(pod_security_policy_config.value.enabled, null)
    }
  }
  
  dynamic "authenticator_groups_config" {
    for_each = try(var.authenticator_groups_config, null) != null ? [var.authenticator_groups_config] : []
    content {
      security_group = try(authenticator_groups_config.value.security_group, null)
    }
  }
  dynamic "private_cluster_config" {
    for_each = try(var.private_cluster_config, null) != null ? [var.private_cluster_config] : []
    content {
      enable_private_nodes = try(private_cluster_config.value.enable_private_nodes, null)
      enable_private_endpoint = try(private_cluster_config.value.enable_private_endpoint, null)
      master_ipv4_cidr_block = try(private_cluster_config.value.master_ipv4_cidr_block, null)
      peering_name = try(private_cluster_config.value.peering_name, null)
      private_endpoint = try(private_cluster_config.value.private_endpoint, null)
      public_endpoint = try(private_cluster_config.value.public_endpoint, null)

      dynamic "master_global_access_config" {
        for_each = try(private_cluster_config.value.master_global_access_config, null)
        content {
          enabled = try(master_global_access_config.value.enabled, null)
        }
      }

      dynamic "reservation_affinity" {
        for_each = try(private_cluster_config.value.reservation_affinity, null) != null ? [private_cluster_config.value.reservation_affinity] : []
        content {

          dynamic "consume_reservation_type" {
            for_each = try(reservation_affinity.value.consume_reservation_type, null) != null ? [reservation_affinity.value.consume_reservation_type] : []
            content {
              UNSPECIFIED = try(consume_reservation_type.value.UNSPECIFIED, null)
              NO_RESERVATION = try(consume_reservation_type.value.NO_RESERVATION, null)
              ANY_RESERVATION = try(consume_reservation_type.value.ANY_RESERVATION, null)
              SPECIFIC_RESERVATION = try(consume_reservation_type.value.SPECIFIC_RESERVATION, null)
            }
          }
          key = var.key
          values = var.values
        }
      }
    }
  }
  
  dynamic "cluster_telemetry" {
    for_each = try(var.cluster_telemetry, null) != null ? [var.cluster_telemetry] : []
    content {
      type = try(cluster_telemetry.value.type, null)
    }
  }

  project = var.project

  dynamic "release_channel" {
    for_each = try(var.release_channel, null) != null ? [var.release_channel] : []
    content {
      channel = try(release_channel.value.channel, null)
    }
  }    
    
  remove_default_node_pool = var.remove_default_node_pool
  resource_labels = var.resource_labels

  dynamic "resource_usage_export_config" {
    for_each = try(var.resource_usage_export_config, null) != null ? [var.resource_usage_export_config] : []
    content {
      enable_network_egress_metering = try(resource_usage_export_config.value.enable_network_egress_metering, null)
      enable_resource_consumption_metering = try(resource_usage_export_config.value.enable_resource_consumption_metering, null)
  
      dynamic "bigquery_destination" {
        for_each = try(resource_usage_export_config.value.bigquery_destination, null) != null ? [resource_usage_export_config.value.bigquery_destination] : []
        content {
        dataset_id = try(bigquery_destination.value.dataset_id, null)
        }
      }
    }
  } 

  subnetwork = var.subnetwork
  dynamic "vertical_pod_autoscaling" {
    for_each = try(var.vertical_pod_autoscaling, null) != null ? [var.vertical_pod_autoscaling] : []
    content {
      enabled = try(vertical_pod_autoscaling.value.enabled, null)
    }
  }

  dynamic "workload_identity_config" {
    for_each = try(var.workload_identity_config, null) != null ? [var.workload_identity_config] : []
    content {
      workload_pool = try(workload_identity_config.value.workload_pool, null)
    }
  }
    
  enable_intranode_visibility = var.enable_intranode_visibility
    enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting
  private_ipv6_google_access = var.private_ipv6_google_access
  datapath_provider = var.datapath_provider
  dynamic "default_snat_status" {
    for_each = try(var.default_snat_status, null) != null ? [var.default_snat_status] : []
    content {
      disabled = try(default_snat_status.value.disabled, null)
    }
  }

  dynamic "dns_config" {
    for_each = try(var.dns_config, null) != null ? [var.dns_config] : []
    content {
      cluster_dns = try(dns_config.value.cluster_dns, null)
      cluster_dns_scope = try(dns_config.value.cluster_dns_scope, null)
      cluster_dns_domain = try(dns_config.value.cluster_dns_domain, null)
    }
  }
}