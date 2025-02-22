#!/bin/sh
set -e

echo "Waiting for database to become available..."
while ! nc -z postgres_db 5432; do
  sleep 1
done
echo "Database is ready!"

. /terraform_terragrunt_postgres/set_env.sh

echo "Running Alembic migrations..."
alembic upgrade head
