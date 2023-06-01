output "mysql_cluster_id" {
  description = "MySQL cluster ID"
  value       = try(module.db.cluster_id, null)
}

output "mysql_cluster_name" {
  description = "MySQL cluster name"
  value       = try(module.db.cluster_name, null)
}

output "mysql_cluster_host_names_list" {
  description = "MySQL cluster host name list"
  value       = try(module.db.cluster_host_names_list, null)
}

output "mysql_cluster_fqdns_list" {
  description = "MySQL cluster FQDNs list"
  value       = try(module.db.cluster_fqdns_list, null)
}

output "db_owners" {
  description = "A list of DB owners users with password."
  value       = try(module.db.owners_data, null)
}

output "db_users" {
  sensitive   = true
  description = "A list of separate DB users with passwords."
  value       = try(module.db.users_data, null)
}

output "mysql_databases" {
  description = "A list of database names."
  value       = try(module.db.databases, null)
}

output "mysql_connection_step_1" {
  description = "1 step - Install certificate"
  value       = try(module.db.connection_step_1, null)
}
output "mysql_connection_step_2" {
  description = "2 step - Execute psql command for a connection to the cluster"
  value       = try(module.db.connection_step_2, null)
}
