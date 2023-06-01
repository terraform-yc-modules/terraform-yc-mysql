# main.tf

module "db" {
  source = "../../"

  network_id               = yandex_vpc_network.vpc.id
  name                     = "one-two-tree"
  description              = "Multi-node MySQL cluster for test purposes"
  security_groups_ids_list = var.security_groups_enabled == true ? [yandex_vpc_security_group.mysql_sg[0].id] : null

  hosts_definition = [
    {
      name             = "one"
      priority         = 0
      zone             = "ru-central1-a"
      assign_public_ip = true
      subnet_id        = yandex_vpc_subnet.sub_a.id
    },
    {
      name             = "two"
      priority         = 10
      zone             = "ru-central1-b"
      assign_public_ip = true
      subnet_id        = yandex_vpc_subnet.sub_b.id
    },
    {
      name                    = "suntree"
      zone                    = "ru-central1-b"
      assign_public_ip        = true
      subnet_id               = yandex_vpc_subnet.sub_b.id
      replication_source_name = "two"
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
    }
  ]
}
