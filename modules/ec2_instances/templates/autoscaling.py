import boto3
import os

ecs = boto3.client('ecs')
cw = boto3.client('cloudwatch')

# Defaults
_CONTAINER_MAX_CPU = 1024
_CONTAINER_MAX_MEM = 768
_CLUSTER = 'default'
# Override with Environment Vars if available
CONTAINER_MAX_CPU = os.environ.get('CONTAINER_MAX_CPU', _CONTAINER_MAX_CPU)
CONTAINER_MAX_MEM = os.environ.get('CONTAINER_MAX_MEM', _CONTAINER_MAX_MEM)
CLUSTER = os.environ.get('CLUSTER', _CLUSTER)

def handler(event, context):
    """
    Check CPU and Memory availability for each instance in the cluster
    Report to cloudwatch the number of containers we can schedule
    Original Author: https://github.com/joh-m
    """
    print('Calculating schedulable containers for cluster %s' % CLUSTER)
    instance_list = ecs.list_container_instances(cluster=CLUSTER, status='ACTIVE')
    instances = ecs.describe_container_instances(cluster=CLUSTER,
                                                 containerInstances=instance_list['containerInstanceArns'])

    schedulable_containers = 0

    for instance in instances['containerInstances']:
        remaining_resources = {resource['name']: resource for resource in instance['remainingResources']}

        containers_by_cpu = int(remaining_resources['CPU']['integerValue'] / CONTAINER_MAX_CPU)
        containers_by_mem = int(remaining_resources['MEMORY']['integerValue'] / CONTAINER_MAX_MEM)

        schedulable_containers += min(containers_by_cpu, containers_by_mem)

        print('%s containers could be scheduled on %s based on CPU only' % (containers_by_cpu, instance['ec2InstanceId']))
        print('%s containers could be scheduled on %s based on memory only' % (containers_by_mem, instance['ec2InstanceId']))

    print('Schedulable containers: %s' % schedulable_containers)

    cw.put_metric_data(Namespace='AWS/ECS',
                       MetricData=[{
                           'MetricName': 'SchedulableContainers',
                           'Dimensions': [{
                               'Name': 'ClusterName',
                               'Value': CLUSTER
                           }],
                           'Timestamp': datetime.datetime.now(dateutil.tz.tzlocal()),
                           'Value': schedulable_containers
                       }])

    print('Metric was send to CloudWatch')
    return {}