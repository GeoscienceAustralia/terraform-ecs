#!/bin/bash
echo "Deploying $1"

rm -rf .terraform
export WORKSPACE=$1
export AWS_PROFILE="$2"
terraform init -backend-config workspaces/$WORKSPACE/backend.cfg
terraform workspace new $WORKSPACE || terraform workspace select $WORKSPACE
terraform plan -input=false -var-file="workspaces/$WORKSPACE/terraform.tfvars" -out "{$1}.plan"
rm "{$1}.plan"
