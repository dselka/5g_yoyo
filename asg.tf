resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 5
  
  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.web_elb.id}"
  ]
launch_configuration = "${aws_launch_configuration.web.name}"
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
metrics_granularity = "1Minute"
vpc_zone_identifier  = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]
# Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

 resource "aws_autoscaling_policy" "web_policy_up" {
   name = "web_policy_up"
   scaling_adjustment = 1
   adjustment_type = "ChangeInCapacity"
   cooldown = 300
   autoscaling_group_name = "${aws_autoscaling_group.web.name}"
 }
 resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
   alarm_name = "web_cpu_alarm_up"
   comparison_operator = "GreaterThanOrEqualToThreshold"
   evaluation_periods = "1"
   metric_name = "CPUUtilization"
   namespace = "AWS/EC2"
   period = "60"
   statistic = "Average"
   threshold = "50"
 dimensions = {
     AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
   }
 alarm_description = "This metric monitor EC2 instance CPU utilization"
   alarm_actions = [ "${aws_autoscaling_policy.web_policy_up.arn}" ]
 }
 resource "aws_autoscaling_policy" "web_policy_down" {
   name = "web_policy_down"
   scaling_adjustment = -1
   adjustment_type = "ChangeInCapacity"
   cooldown = 300
   autoscaling_group_name = "${aws_autoscaling_group.web.name}"
 }
 resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
   alarm_name = "web_cpu_alarm_down"
   comparison_operator = "LessThanOrEqualToThreshold"
   evaluation_periods = "1"
   metric_name = "CPUUtilization"
   namespace = "AWS/EC2"
   period = "60"
   statistic = "Average"
   threshold = "10"
 dimensions = {
     AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
   }
 alarm_description = "This metric monitor EC2 instance CPU utilization"
   alarm_actions = [ "${aws_autoscaling_policy.web_policy_down.arn}" ]
 }

 resource "aws_sns_topic" "autoscaling_notifications" {
  name = "autoscaling-notifications"
}

resource "aws_autoscaling_notification" "notifications" {
  group_names = [
    aws_autoscaling_group.web.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.autoscaling_notifications.arn
}

