terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.25.0"
    }
  }
}

provider "postgresql" {
  alias = "default"
  host     = lookup(var.env_vars, "db_host", "" )
  port     = lookup(var.env_vars, "db_port", "" )
  username = lookup(var.env_vars, "db_username", "" )
  password = lookup(var.env_vars, "db_password", "" )
  database = lookup(var.env_vars, "db_name", "" )
  sslmode  = "disable"
}
