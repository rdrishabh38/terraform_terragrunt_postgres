# /terraform_terragrunt_postgres/envs/dev/root.hcl
include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  env_vars = {
    db_host     = "postgres_db"   # Use the service name as defined in docker-compose.yaml
    db_port     = "5432"          # Internal port of the Postgres container
    db_username = "admin"
    db_password = "admin"
    db_name     = "master_db"
  }
  product_data = {
    PRODUCT_1 = {
      product_name = "product_1",
      product_description = "first product"
    },
    PRODUCT_2 = {
      product_name = "product_2",
      product_description = "second product"
    }
  }
}
