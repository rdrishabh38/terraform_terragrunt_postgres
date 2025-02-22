# /terraform_terragrunt_postgres/root.hcl
# Base configuration shared across all environments

# Uncomment this as per your use case. Since this is a test repo, I do not require to maintain states.
#remote_state {
#  backend = "s3"
#  config = {
#    bucket         = "my-terraform-state-bucket"
#    key            = "${path_relative_to_include()}/terraform.tfstate"
#    region         = "us-east-1"
#    encrypt        = true
#    dynamodb_table = "my-lock-table"
#  }
#}

# For local state
#remote_state {
#  backend = "local"
#  config = {
#    path = "${path_relative_to_include()}/terraform.tfstate"
#  }
#}


terraform {
  # The source path is relative to this file.
  source = "../../terraform_source"
}
