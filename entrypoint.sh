#!/bin/sh
set -e

. /terraform_terragrunt_postgres/set_env.sh

export TF_INPUT=0

echo "Waiting for database to become available..."
while ! nc -z postgres_db 5432; do
  sleep 1
done
echo "Database is ready!"

# commented as passing credentials via terragrunt layer now
# for specific environment as per the requirement.
# . /terraform_terragrunt_postgres/set_env.sh

echo "Running Alembic migrations..."
/venv/bin/alembic upgrade head

cd /terraform_terragrunt_postgres/environments/dev

terragrunt init --reconfigure

terragrunt plan

terragrunt apply --auto-approve

# Keep container running (if needed)
tail -f /dev/null
