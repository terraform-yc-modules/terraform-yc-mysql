# Yandex Cloud Managed MySQL Cluster

## Features

- Create a Managed MySQL cluster with predefined number of DB hosts
- Create a list of users and databases with permissions
- Easy to use in other resources via outputs

## MySQL cluster definition

At first you need to create VPC network with three subnets!

MySQL module requires a following input variables:
 - VPC network id
 - VPC network subnets ids
 - MySQL hosts definitions - a list of maps with DB host name, zone name and subnet id.
 - Databases - a list of databases with database name
 - Users - a list users with a list of grants to databases.

<b>Notes:</b>
1. `users` variable defines a list of separate db users with a `permissions` list, which indicates to a list of databases and grants for each of them. Default grant is the "ALL_PRIVILEGES". The user may also have `global_permissions` without any database permissions.
2. Database `mysql_config` parameter might be null, in this case default values will be used.

### Example

See [examples section](./examples/)

### Configure Terraform for Yandex Cloud

- Install [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
- Add environment variables for terraform auth in Yandex.Cloud

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export TF_VAR_network_id=_vpc id here_
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | > 3.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | > 0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.89.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [yandex_mdb_mysql_cluster.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster) | resource |
| [yandex_mdb_mysql_database.database](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_database) | resource |
| [yandex_mdb_mysql_user.user](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_user) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy"></a> [access\_policy](#input\_access\_policy) | Access policy from other services to the MySQL cluster. | <pre>object({<br>    data_lens     = optional(bool, null)<br>    web_sql       = optional(bool, null)<br>    data_transfer = optional(bool, null)<br>  })</pre> | `{}` | no |
| <a name="input_backup_retain_period_days"></a> [backup\_retain\_period\_days](#input\_backup\_retain\_period\_days) | (Optional) The period in days during which backups are stored. | `number` | `null` | no |
| <a name="input_backup_window_start"></a> [backup\_window\_start](#input\_backup\_window\_start) | (Optional) Time to start the daily backup, in the UTC timezone. | <pre>object({<br>    hours   = string<br>    minutes = optional(string, "00")<br>  })</pre> | `null` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | A list of MySQL databases.<br><br>    Required values:<br>      - name        - The name of the database. | <pre>list(object({<br>    name = string<br>  }))</pre> | `[]` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Inhibits deletion of the cluster. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | MySQL cluster description | `string` | `"Managed MySQL cluster"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Disk size for hosts | `number` | `20` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Disk type for hosts | `string` | `"network-ssd"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment type: PRODUCTION or PRESTABLE | `string` | `"PRODUCTION"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder id that contains the MySQL cluster | `string` | `null` | no |
| <a name="input_hosts_definition"></a> [hosts\_definition](#input\_hosts\_definition) | A list of MySQL hosts. | <pre>list(object({<br>    name                    = optional(string, null)<br>    zone                    = string<br>    subnet_id               = optional(string, null)<br>    assign_public_ip        = optional(bool, false)<br>    replication_source_name = optional(string, null)<br>    priority                = optional(number, null)<br>    backup_priority         = optional(number, null)<br>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of label pairs to assing to the MySQL cluster. | `map(any)` | `{}` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Optional) Maintenance policy of the MySQL cluster.<br>      - type - (Required) Type of maintenance window. Can be either ANYTIME or WEEKLY. A day and hour of window need to be specified with weekly window.<br>      - day  - (Optional) Day of the week (in DDD format). Allowed values: "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"<br>      - hour - (Optional) Hour of the day in UTC (in HH format). Allowed value is between 0 and 23. | <pre>object({<br>    type = string<br>    day  = optional(string, null)<br>    hour = optional(string, null)<br>  })</pre> | <pre>{<br>  "type": "ANYTIME"<br>}</pre> | no |
| <a name="input_mysql_config"></a> [mysql\_config](#input\_mysql\_config) | A map of MySQL cluster configuration.<br>    Details info in a 'MySQL cluster settings' of official documentation.<br>    Link: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster#mysql-config | `map(any)` | `null` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | MySQL version | `string` | `"8.0"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of MySQL cluster | `string` | `"mysql-cluster"` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | MySQL cluster network id | `string` | n/a | yes |
| <a name="input_performance_diagnostics"></a> [performance\_diagnostics](#input\_performance\_diagnostics) | (Optional) MySQL cluster performance diagnostics settings. | <pre>object({<br>    enabled                      = optional(bool, null)<br>    sessions_sampling_interval   = optional(number, 60)<br>    statements_sampling_interval = optional(number, 600)<br>  })</pre> | `{}` | no |
| <a name="input_resource_preset_id"></a> [resource\_preset\_id](#input\_resource\_preset\_id) | Preset for hosts | `string` | `"s2.micro"` | no |
| <a name="input_restore_parameters"></a> [restore\_parameters](#input\_restore\_parameters) | The cluster will be created from the specified backup.<br>    NOTES:<br>      - backup\_id must be specified to create a new MySQL cluster from a backup.<br>      - Time format is 'yyyy-mm-ddThh:mi:ss', where T is a delimeter, e.g. "2022-02-22T11:33:44". | <pre>object({<br>    backup_id = string<br>    time      = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_security_groups_ids_list"></a> [security\_groups\_ids\_list](#input\_security\_groups\_ids\_list) | A list of security group IDs to which the MySQL cluster belongs | `list(string)` | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | This is a list for additional MySQL users with own permissions. <br><br>    Required values:<br>      - name                  - The name of the user.<br>      - password              - (Optional) The user's password. If it's omitted a random password will be generated<br>      - authentication\_plugin - (Optional) User authn method. The default value could be set <br>                                via the 'mysql\_config.default\_authentication\_plugin' variable.<br>      - global\_permissions    - (Optional) A list of the user's global\_permissions. Default empty.<br>      - connection\_limits     - (Optional) The object with user connection limits <br>                                { max\_questions\_per\_hour, max\_updates\_per\_hour, max\_connections\_per\_hour, <br>                                max\_user\_connections }. Default unlimited.<br>      - permissions           - (Optional) A list of objects { databases\_name, grants[] } for an access.<br>                                'roles' is a optional list of permissions, the default values is ["ALL"] | <pre>list(object({<br>    name                  = string<br>    password              = optional(string, null)<br>    authentication_plugin = optional(string, null)<br>    global_permissions    = optional(list(string), [])<br>    connection_limits = optional(object({<br>      max_questions_per_hour   = optional(number, -1)<br>      max_updates_per_hour     = optional(number, -1)<br>      max_connections_per_hour = optional(number, -1)<br>      max_user_connections     = optional(number, -1)<br>    }), null)<br>    permissions = optional(list(object({<br>      database_name = string<br>      roles         = optional(list(string), ["ALL"])<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_fqdns_list"></a> [cluster\_fqdns\_list](#output\_cluster\_fqdns\_list) | MySQL cluster nodes FQDN list |
| <a name="output_cluster_host_names_list"></a> [cluster\_host\_names\_list](#output\_cluster\_host\_names\_list) | MySQL cluster host name |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | MySQL cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | MySQL cluster name |
| <a name="output_connection_step_1"></a> [connection\_step\_1](#output\_connection\_step\_1) | 1 step - Install certificate |
| <a name="output_connection_step_2"></a> [connection\_step\_2](#output\_connection\_step\_2) | How connect to MySQL cluster?<br><br>    1. Install certificate<br><br>      mkdir --parents \~/.mysql && \\<br>      curl -fsL 'https://storage.yandexcloud.net/cloud-certs/CA.pem' -o \~/.mysql/root.crt && \\<br>      chmod 0600 \~/.mysql/root.crt<br><br>    2. Run connection string from the output value, for example<br><br>      mysql --host=rc1a-ud9hj90vwqkw05js.mdb.yandexcloud.net \\<br>        --port=3306 \\<br>        --ssl-ca=\~/.mysql/root.crt \\<br>        --ssl-mode=VERIFY\_IDENTITY \\<br>        --user=test1-owner \\<br>        --password \\<br>        test1 |
| <a name="output_databases"></a> [databases](#output\_databases) | A list of databases names. |
| <a name="output_users_data"></a> [users\_data](#output\_users\_data) | A list of users with passwords. |
<!-- END_TF_DOCS -->
