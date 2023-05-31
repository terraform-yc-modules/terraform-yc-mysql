# main.tf

module "db" {
  source = "../../"

  network_id               = yandex_vpc_network.vpc.id
  name                     = "alone-in-the-dark"
  description              = "Single-node MySQL cluster for test purposes"
  security_groups_ids_list = var.security_groups_enabled == true ? [yandex_vpc_security_group.mysql_sg[0].id] : null

  maintenance_window = {
    type = "WEEKLY"
    day  = "SUN"
    hour = "02"
  }

  access_policy = {
    web_sql = true
  }

  performance_diagnostics = {
    enabled = true
  }

  hosts_definition = [
    {
      zone             = "ru-central1-a"
      assign_public_ip = true
      subnet_id        = yandex_vpc_subnet.sub.id
    }
  ]

  mysql_config = {
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
    transaction_isolation         = "READ_COMMITTED"
    character_set_server          = "utf8"
    collation_server              = "utf8_unicode_ci"
  }

  databases = [{ "name" : "test1" }]

  users = [
    {
      name        = "test1-owner"
      permissions = [{ "database_name" : "test1" }]
    },
    {
      name        = "test1-ro"
      permissions = [{ "database_name" : "test1", "roles" : ["SELECT"] }]
    },
    {
      name               = "test1-proc"
      global_permissions = ["PROCESS"]
    }
  ]
}
