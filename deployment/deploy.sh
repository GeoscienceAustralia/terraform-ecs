#!/bin/sh -e

#Usage: CONTAINER_VERSION=docker_container_version [create|update]

# register task-definition
sed <td-nginx.template -e "s,@VERSION@,$1," > TASKDEF.json

aws ecs register-task-definition --cli-input-json file://TASKDEF.json > REGISTERED_TASKDEF.json
TASKDEFINITION_ARN=$( < REGISTERED_TASKDEF.json jq .taskDefinition.taskDefinitionArn )
cat REGISTERED_TASKDEF.json

# create or update service
sed "s,@@TASKDEFINITION_ARN@@,$TASKDEFINITION_ARN," <service-$2-nginx.json >SERVICEDEF.json
aws ecs $2-service --cli-input-json file://SERVICEDEF.json | tee SERVICE.json
