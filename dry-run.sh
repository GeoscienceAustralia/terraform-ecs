#!/bin/bash
echo "Deploying $1"

rm -rf .terraform
export WORKSPACE=$1
export AWS_PROFILE="$2"
if [ ! -d "workspaces/$WORKSPACE" ]
then
    echo "Could not find workspace directory $WORKSPACE"
    echo "Aborting..."
    exit 1
fi
terraform init -backend-config workspaces/$WORKSPACE/backend.cfg
terraform workspace new $WORKSPACE || terraform workspace select $WORKSPACE
terraform plan -input=false -var-file="workspaces/$WORKSPACE/terraform.tfvars" -out "{$1}.plan"
rm "{$1}.plan"
