
resource "random_password" "password" {
  for_each         = { for v in var.users : v.name => v if v.password == null }
  length           = 16
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_"
}


#  MySQL users with own permissions
resource "yandex_mdb_mysql_user" "user" {
  for_each = length(var.users) > 0 ? { for user in var.users : user.name => user } : {}

  cluster_id            = yandex_mdb_mysql_cluster.this.id
  name                  = each.value.name
  password              = each.value.password == null ? random_password.password[each.value.name].result : each.value.password
  authentication_plugin = lookup(each.value, "authentication_plugin", null)

  global_permissions = each.value.global_permissions

  dynamic "connection_limits" {
    for_each = each.value.connection_limits == null ? [] : [each.value.connection_limits]
    content {
      max_questions_per_hour   = connection_limits.value.max_questions_per_hour
      max_updates_per_hour     = connection_limits.value.max_updates_per_hour
      max_connections_per_hour = connection_limits.value.max_connections_per_hour
      max_user_connections     = connection_limits.value.max_user_connections
    }
  }

  dynamic "permission" {
    for_each = lookup(each.value, "permissions", [])
    content {
      database_name = permission.value.database_name
      roles         = permission.value.roles
    }
  }

  depends_on = [
    yandex_mdb_mysql_database.database
  ]
}
