# Variables
variable "name" {
  description = "Name of MySQL cluster"
  type        = string
  default     = "mysql-cluster"
}

variable "environment" {
  description = "Environment type: PRODUCTION or PRESTABLE"
  type        = string
  default     = "PRODUCTION"
  validation {
    condition     = contains(["PRODUCTION", "PRESTABLE"], var.environment)
    error_message = "Release channel should be PRODUCTION (stable feature set) or PRESTABLE (early bird feature access)."
  }
}

variable "network_id" {
  description = "MySQL cluster network id"
  type        = string
}

variable "description" {
  description = "MySQL cluster description"
  type        = string
  default     = "Managed MySQL cluster"
}

variable "folder_id" {
  description = "Folder id that contains the MySQL cluster"
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of label pairs to assing to the MySQL cluster."
  type        = map(any)
  default     = {}
}

variable "security_groups_ids_list" {
  description = "A list of security group IDs to which the MySQL cluster belongs"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "deletion_protection" {
  description = "Inhibits deletion of the cluster."
  type        = bool
  default     = false
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0"
  validation {
    condition     = contains(["5.7", "8.0"], var.mysql_version)
    error_message = "Allowed MySQL versions are 5.7, 8.0."
  }
}

variable "disk_size" {
  description = "Disk size for hosts"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Disk type for hosts"
  type        = string
  default     = "network-ssd"
}

variable "resource_preset_id" {
  description = "Preset for hosts"
  type        = string
  default     = "s2.micro"
}

variable "access_policy" {
  description = "Access policy from other services to the MySQL cluster."
  type = object({
    data_lens     = optional(bool, null)
    web_sql       = optional(bool, null)
    data_transfer = optional(bool, null)
  })
  default = {}
}

variable "restore_parameters" {
  description = <<EOF
    The cluster will be created from the specified backup.
    NOTES:
      - backup_id must be specified to create a new MySQL cluster from a backup.
      - Time format is 'yyyy-mm-ddThh:mi:ss', where T is a delimeter, e.g. "2022-02-22T11:33:44".
  EOF
  type = object({
    backup_id = string
    time      = optional(string, null)
  })
  default = null
}

variable "maintenance_window" {
  description = <<EOF
    (Optional) Maintenance policy of the MySQL cluster.
      - type - (Required) Type of maintenance window. Can be either ANYTIME or WEEKLY. A day and hour of window need to be specified with weekly window.
      - day  - (Optional) Day of the week (in DDD format). Allowed values: "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
      - hour - (Optional) Hour of the day in UTC (in HH format). Allowed value is between 0 and 23.
  EOF
  type = object({
    type = string
    day  = optional(string, null)
    hour = optional(string, null)
  })
  default = {
    type = "ANYTIME"
  }
}

variable "performance_diagnostics" {
  description = "(Optional) MySQL cluster performance diagnostics settings."
  type = object({
    enabled                      = optional(bool, null)
    sessions_sampling_interval   = optional(number, 60)
    statements_sampling_interval = optional(number, 600)
  })
  default = {}
}

variable "backup_retain_period_days" {
  description = "(Optional) The period in days during which backups are stored."
  type        = number
  default     = null
}

variable "backup_window_start" {
  description = "(Optional) Time to start the daily backup, in the UTC timezone."
  type = object({
    hours   = string
    minutes = optional(string, "00")
  })
  default = null
}

variable "hosts_definition" {
  description = "A list of MySQL hosts."

  type = list(object({
    name                    = optional(string, null)
    zone                    = string
    subnet_id               = optional(string, null)
    assign_public_ip        = optional(bool, false)
    replication_source_name = optional(string, null)
    priority                = optional(number, null)
    backup_priority         = optional(number, null)
  }))
  default = []
}

variable "mysql_config" {
  description = <<EOF
    A map of MySQL cluster configuration.
    Details info in a 'MySQL cluster settings' of official documentation.
    Link: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster#mysql-config
  EOF
  type        = map(any)

  default = null
}

variable "databases" {
  description = <<EOF
    A list of MySQL databases.

    Required values:
      - name        - The name of the database.
  EOF
  type = list(object({
    name = string
  }))
  default = []
}

variable "users" {
  description = <<EOF
    This is a list for additional MySQL users with own permissions. 

    Required values:
      - name                  - The name of the user.
      - password              - (Optional) The user's password. If it's omitted a random password will be generated
      - authentication_plugin - (Optional) User authn method. The default value could be set 
                                via the 'mysql_config.default_authentication_plugin' variable.
      - global_permissions    - (Optional) A list of the user's global_permissions. Default empty.
      - connection_limits     - (Optional) The object with user connection limits 
                                { max_questions_per_hour, max_updates_per_hour, max_connections_per_hour, 
                                max_user_connections }. Default unlimited.
      - permissions           - (Optional) A list of objects { databases_name, grants[] } for an access.
                                'roles' is a optional list of permissions, the default values is ["ALL"]
  EOF

  type = list(object({
    name                  = string
    password              = optional(string, null)
    authentication_plugin = optional(string, null)
    global_permissions    = optional(list(string), [])
    connection_limits = optional(object({
      max_questions_per_hour   = optional(number, -1)
      max_updates_per_hour     = optional(number, -1)
      max_connections_per_hour = optional(number, -1)
      max_user_connections     = optional(number, -1)
    }), null)
    permissions = optional(list(object({
      database_name = string
      roles         = optional(list(string), ["ALL"])
    })), [])
  }))
  default = []
}
