#==============================================================
# ec2_instances / autoscaling.tf
#==============================================================
# Configures our ECS cluster autoscaling rules

# Build a lambda that reports the number of containers we can add to the cluster
# This uses the max CPU and MEM and will report to AWS/ECS SchedulableContainers

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/templates/autoscaling.py"
  output_path = "${path.module}/templates/autoscaling.zip"
}

resource "aws_lambda_function" "schedulable_containers" {
  function_name    = "${var.cluster}_schedulable_containers"
  handler          = "autoscaling.handler"
  runtime          = "python3.6"
  filename         = "${path.module}/templates/autoscaling.zip"
  timeout          = 60
  source_code_hash = "${data.archive_file.lambda.output_sha}"
  role             = "${aws_iam_role.lambda_exec_role.arn}"

  environment {
    variables = {
      container_max_cpu = "${var.max_container_cpu}"
      container_max_mem = "${var.max_container_mem}"
    }
  }
}

# Cloudwatch to trigger the lambda
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "invoke-${var.cluster}-schedulable-containers"
  description         = "Fires every ${var.autoscaling_evaluation_time} minutes"
  schedule_expression = "rate(${var.autoscaling_evaluation_time} minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_execution" {
  rule      = "${aws_cloudwatch_event_rule.schedule.name}"
  target_id = "${var.cluster}_schedulable_containers"
  arn       = "${aws_lambda_function.schedulable_containers.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.schedulable_containers.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.schedule.arn}"
}

# Scale out the cluster if we can no longer add containers

resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "${var.cluster}SchedulableContainersLowAlert"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "SchedulableContainers"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Minimum"
  threshold           = "${var.min_container_num}"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_description = "Alarm if less than min container can be scheduled"
  alarm_actions     = ["${aws_autoscaling_policy.scale_out.arn}"]
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.cluster}ScaleOut"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

# Scale in the cluster if we can add too many containers (overprovisioned)

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "${var.cluster}SchedulableContainersHighAlert"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "SchedulableContainers"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Minimum"
  threshold           = "${var.max_container_num}"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_description = "Alarm if more than max containers can be scheduled"
  alarm_actions     = ["${aws_autoscaling_policy.scale_in.arn}"]
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.cluster}ScaleIn"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

# Lambda Policies

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.cluster}.lambda.schedulable_containers"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "schedulable_containers" {
  statement {
    sid = "1"

    actions = [
      "cloudwatch:PutMetricData",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "schedulable_containers" {
  name   = "${var.cluster}LambdaScheduleableContainers"
  path   = "/"
  policy = "${data.aws_iam_policy_document.schedulable_containers.json}"
}

resource "aws_iam_role_policy_attachment" "attach-lambda-execution-policy" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach-lambda-metric-policy" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.schedulable_containers.arn}"
}
