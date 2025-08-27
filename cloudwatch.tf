# Creating Cloudwatch metric alarm
resource "aws_cloudwatch_metric_alarm" "cloudwatch" {
  alarm_name = "terraform-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  period = 60
  statistic = "Average"
  namespace = "CWAgent_alarm"
  threshold = var.default_CPU_treshold
  alarm_description = "This metric monitors EC2's CPU Utilization"
  insufficient_data_actions = []
# Connecting SNS to cloudwatch
  alarm_actions = [aws_sns_topic.sns_cloudwatch.arn]
  count = length(module.my_instance.instance_id)
  dimensions = {
    Instance_Id = module.my_instance.instance_id[count.index]
  }
}
output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.cloudwatch[*].alarm_name
}