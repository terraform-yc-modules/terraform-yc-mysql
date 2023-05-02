data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}

# MySQL cluster
resource "yandex_mdb_mysql_cluster" "this" {
  name                      = var.name
  description               = var.description
  environment               = var.environment
  network_id                = var.network_id
  folder_id                 = local.folder_id
  labels                    = var.labels
  version                   = var.mysql_version
  deletion_protection       = var.deletion_protection
  security_group_ids        = var.security_groups_ids_list
  backup_retain_period_days = var.backup_retain_period_days

  mysql_config = var.mysql_config

  resources {
    disk_size          = var.disk_size
    disk_type_id       = var.disk_type
    resource_preset_id = var.resource_preset_id
  }

  dynamic "access" {
    for_each = range(var.access_policy == null ? 0 : 1)
    content {
      data_lens     = var.access_policy.data_lens
      web_sql       = var.access_policy.web_sql
      data_transfer = var.access_policy.data_transfer
    }
  }

  dynamic "performance_diagnostics" {
    for_each = range(var.performance_diagnostics == null ? 0 : 1)
    content {
      enabled                      = var.performance_diagnostics.enabled
      sessions_sampling_interval   = var.performance_diagnostics.sessions_sampling_interval
      statements_sampling_interval = var.performance_diagnostics.statements_sampling_interval
    }
  }

  dynamic "backup_window_start" {
    for_each = range(var.backup_window_start == null ? 0 : 1)
    content {
      hours   = var.backup_window_start.hours
      minutes = var.backup_window_start.minutes
    }
  }

  dynamic "host" {
    for_each = var.hosts_definition
    content {
      name                    = host.value.name
      zone                    = host.value.zone
      subnet_id               = host.value.subnet_id
      assign_public_ip        = host.value.assign_public_ip
      priority                = host.value.priority
      replication_source_name = host.value.replication_source_name
    }
  }

  dynamic "restore" {
    for_each = range(var.restore_parameters == null ? 0 : 1)
    content {
      backup_id = var.restore_parameters.backup_id
      time      = var.restore_parameters.time
    }
  }

  dynamic "maintenance_window" {
    for_each = range(var.maintenance_window == null ? 0 : 1)
    content {
      type = var.maintenance_window.type
      day  = var.maintenance_window.day
      hour = var.maintenance_window.hour
    }
  }
}

#### .mylogin.cnf

