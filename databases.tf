# Mysql databases
resource "yandex_mdb_mysql_database" "database" {
  for_each = length(var.databases) > 0 ? { for db in var.databases : db.name => db } : {}

  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = lookup(each.value, "name", null)
}
