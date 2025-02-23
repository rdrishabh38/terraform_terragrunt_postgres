#!/bin/bash
# set_env.sh - export PostgreSQL connection variables for Terraform

# DO NOT DO THIS IN PRODUCTION. RUN THIS SCRIPT VIA JENKINS OR SOMETHING ELSE ENTIRELY.
# DO NOT PUSH CREDENTIALS TO GIT. THIS IS JUST A SETUP FOR LOCAL DEVELOPMENT.

export db_host="postgres_master"       # Docker Compose service name for your PostgreSQL container
export db_port="5432"               # Internal port (not the mapped external port)
export db_username="admin"
export db_password="admin"
export db_name="master_db"
