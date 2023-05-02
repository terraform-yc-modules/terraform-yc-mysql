output "cluster_id" {
  description = "MySQL cluster ID"
  value       = yandex_mdb_mysql_cluster.this.id
}

output "cluster_name" {
  description = "MySQL cluster name"
  value       = yandex_mdb_mysql_cluster.this.name
}

output "cluster_host_names_list" {
  description = "MySQL cluster host name"
  value       = [yandex_mdb_mysql_cluster.this.host[*].name]
}

output "cluster_fqdns_list" {
  description = "MySQL cluster nodes FQDN list"
  value       = [yandex_mdb_mysql_cluster.this.host[*].fqdn]
}

output "users_data" {
  sensitive   = true
  description = "A list of users with passwords."
  value = [
    for u in yandex_mdb_mysql_user.user : {
      user     = u["name"]
      password = u["password"]
    }
  ]
}

output "databases" {
  description = "A list of databases names."
  value       = [for db in var.databases : db.name]
}

output "connection_step_1" {
  description = "1 step - Install certificate"
  value       = "mkdir --parents ~/.mysql && curl -fsL 'https://storage.yandexcloud.net/cloud-certs/CA.pem' -o ~/.mysql/root.crt && chmod 0600 ~/.mysql/root.crt"
}

output "connection_step_2" {
  description = <<EOF
    How connect to MySQL cluster?

    1. Install certificate
    
      mkdir --parents \~/.mysql && \\
      curl -fsL 'https://storage.yandexcloud.net/cloud-certs/CA.pem' -o \~/.mysql/root.crt && \\
      chmod 0600 \~/.mysql/root.crt
    
    2. Run connection string from the output value, for example
    
      mysql --host=rc1a-ud9hj90vwqkw05js.mdb.yandexcloud.net \\
        --port=3306 \\
        --ssl-ca=\~/.mysql/root.crt \\
        --ssl-mode=VERIFY_IDENTITY \\
        --user=test1-owner \\
        --password \\
        test1
  EOF

  value = "mysql --host=c-${yandex_mdb_mysql_cluster.this.id}.rw.mdb.yandexcloud.net --port=3306 --ssl-ca=~/.mysql/root.crt --ssl-mode=VERIFY_IDENTITY --user=${var.users[0]["name"]} ${var.databases[0]["name"]} --password"
}
