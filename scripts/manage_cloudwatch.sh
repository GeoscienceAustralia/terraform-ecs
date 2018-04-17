#! /bin/bash
# Imports / removes cloudwatch log groups defined in ec2_instances module
# first argument either import or rm (required)
# second argument specifies ec2 module name (required)
# third argument specifies a cloudwatch prefix if needed (optional defaults to empty)
# manage_cloudwatch.sh import ec2_instances cld_watch

TF_CLOUDWATCH=(
"dmesg,/var/log/dmesg"
"docker,/var/log/docker"
"ecs-agent,/var/log/ecs/ecs-agent.log"
"ecs-init,/var/log/ecs/ecs-init.log"
"audit,/var/log/ecs/audit.log"
"messages,/var/log/messages"
)

action=${1:-"import"}
module_name=${2:-"ec2_instances"}
cloudwatch_prefix=${3:-}

for tuple in "${TF_CLOUDWATCH[@]}"
do
    IFS=","
    set -- $tuple
    if [ $action = "import" ]
    then
        terraform import module.$module_name.aws_cloudwatch_log_group.$1 $cloudwatch_prefix$2
    else
        terraform state rm module.$module_name.aws_cloudwatch_log_group.$1
    fi
done
