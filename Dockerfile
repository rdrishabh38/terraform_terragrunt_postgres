# Use official Python 3.11 slim image as the base
FROM python:3.11-slim

# Install git to clone the repository
RUN apt-get update && apt-get install -y git netcat-openbsd

# Clone the latest project from GitHub
RUN git clone https://github.com/rdrishabh38/terraform_terragrunt_postgres.git /terraform_terragrunt_postgres

# Set the working directory
WORKDIR /terraform_terragrunt_postgres

# Install necessary system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Install Terraform
# Define the Terraform version you want to install
ARG TERRAFORM_VERSION=1.10.5
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/terraform && \
    rm terraform.zip

# Install Terragrunt
RUN curl -Lo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 && \
    chmod +x /usr/local/bin/terragrunt

# Create a Python virtual environment at /venv
RUN python -m venv venv

RUN venv/bin/pip install --upgrade pip

# Install dependencies inside the virtual environment
RUN venv/bin/pip install --no-cache-dir -r requirements.txt

# Ensure the virtual environment's binaries are used by default
ENV PATH="/terraform_terragrunt_postgres/venv/bin:$PATH"

# RUN the entrypoint script
RUN chmod +x /terraform_terragrunt_postgres/entrypoint.sh

# Set the entrypoint so that migrations run at container startup
ENTRYPOINT ["/terraform_terragrunt_postgres/entrypoint.sh"]

# Keep the container running
CMD ["tail", "-f", "/dev/null"]
